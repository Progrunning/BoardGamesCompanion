enum PlaysTab {
  history,
  statistics,
  selectGame,
}

extension ToPlaysTab on int {
  PlaysTab toPlaysTab() {
    switch (this) {
      case 0:
        return PlaysTab.history;
      case 1:
        return PlaysTab.statistics;
      case 2:
        return PlaysTab.selectGame;
    }

    return PlaysTab.history;
  }
}
