import React, { useState } from 'react';
import { View, FlatList } from 'react-native';
import BallCard from './BallCard';
import AddBall from './AddBall';

const Balls = () => {
  const [balls, setBalls] = useState([]);

  return (
    <View>
      <FlatList
        data={balls}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => <BallCard ball={item} />}
      />
      <AddBall />
    </View>
  );
};

export default Balls; 