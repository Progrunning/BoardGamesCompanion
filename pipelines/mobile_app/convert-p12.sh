#!/usr/bin/env bash
# Re-encrypts a Keychain Access .p12 export so that it can be read by both OpenSSL 3 (used by the
# InstallAppleCertificate@2 pipeline task) and macOS `security import`.
#
# Usage: ./convert-p12.sh <keychain-export.p12> [output.p12]
# Passwords are prompted for (not passed as arguments) so they stay out of shell history.
set -euo pipefail

in="${1:?Usage: $0 <keychain-export.p12> [output.p12]}"
out="${2:-Progrunning_Distribution_Cert.p12}"

read -rsp "Password of the exported .p12: " OLD_PW; echo
read -rsp "New password for the converted .p12: " NEW_PW; echo
export OLD_PW NEW_PW

umask 077
work="$(mktemp -d)"
keychain="$work/verify.keychain"
trap 'security delete-keychain "$keychain" >/dev/null 2>&1 || true; rm -rf "$work"' EXIT

# Keychain Access writes RC2-40 encrypted certs, which OpenSSL 3 only reads with -legacy.
openssl pkcs12 -legacy -in "$in" -passin env:OLD_PW -nodes -out "$work/id.pem"

# 3DES + SHA-1 is the one combination OpenSSL 3 (default provider) and `security import` both accept.
# AES-256 / SHA-256 is rejected by `security import` on some macOS versions.
openssl pkcs12 -export -in "$work/id.pem" -out "$out" -passout env:NEW_PW \
  -certpbe PBE-SHA1-3DES -keypbe PBE-SHA1-3DES -macalg SHA1

echo "Verifying with OpenSSL 3 (no -legacy)..."
openssl pkcs12 -in "$out" -passin env:NEW_PW -nokeys -noout

echo "Verifying with macOS security import..."
security create-keychain -p verify "$keychain"
security import "$out" -k "$keychain" -P "$NEW_PW"

echo "Done: $out"
echo "Next: replace the secure file in Azure DevOps and update the iOSProgrunningDistributionCert variable."
