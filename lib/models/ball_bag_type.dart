enum BallBagType {
  all('Default'),
  competition('比賽用球袋'),
  practice('練球用球袋');

  const BallBagType(this.displayName);
  
  final String displayName;
} 