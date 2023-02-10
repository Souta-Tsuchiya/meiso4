enum HeaderType {
  LEVELS,
  THEME,
  TIME
}

enum RunningStatus {
  BEFORE_START,
  ON_START,
  INHALE,
  HOLD,
  EXHALE,
  FINISHED,
  PAUSE,
}

const int INITIAL_INTERVAL_SECONDS = 3;

enum PurchasePattern {
  DONATE,
  DELETE_AD,
  SUBSCRIBE,
}