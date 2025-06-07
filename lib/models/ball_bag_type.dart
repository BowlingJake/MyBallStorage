enum BallBagType {
  competition('比賽用球袋'),
  practice('練球用球袋'),
  all('全部球袋');

  const BallBagType(this.displayName);
  
  final String displayName;
} 