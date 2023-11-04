# Overview

The worker is designed to run as a background service that listens and processes board game cache update service bus messages.

The BGC.Function `UpdateBoardGameCacheFunction` does exactly the same thing but running a function in Azure causes unreasonably high storage usage [(see details)](https://github.com/Azure/Azure-Functions/issues/2417)
and causes the cost of running the service to increase significantly there was a need to disable the function and use this worker instead.

# Deploying and running

This worker should be run on a machine that is always on. One of the approaches is to have it running on a ARM single-board computer (SBC) (e.g. Rasperry PI).

For more details on the build and deployment process go to https://learn.microsoft.com/en-us/dotnet/iot/deployment#deploying-a-self-contained-app

## Build

Run the following command to create a DLL that will be suitable be run on an SBC `dotnet publish --runtime linux-arm --self-contained`

> NOTE: If running on arm 64 device than the `--runtime` parameter will need to be specified as `linux-arm64`. You can check SBC's architecture by runnig the following command `getconf LONG_BIT`
> NOTE: The `--self-contained` flag will ensure that the .NET runtime is packages with the DLL so there won't be a need to install the runtime on the SBC itself.

### Run on SBC

Upon successful generation of DLLs for the project copy the files across to the SBC with the command `scp -r /publish-location/* pi@<ip_address>:/home/pi/deployment-location/`. For example:

```
scp -r D:\Dev\Projects\BoardGamesCompanion\backend\cache\BGC.UpdateBoardGameCacheWorker\bin\Debug\net7.0\linux-arm\publish\* pi@192.168.1.116:/home/pi/Dev/BGC/UpdateBoardGameCacheWorker
```

Then give executable permission to the executable file by running the command `chmod +x <executable_file>` and finally launch the app `./<executable_file>`