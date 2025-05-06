import React, { useState } from 'react';
import { View, Text, Pressable, Button, StyleSheet } from 'react-native';

const genres = ['Pop', 'Rock', 'Hip-Hop', 'Jazz'];
const difficulties = ['Easy', 'Medium', 'Hard'];

export default function HomeScreen({ navigation }) {
  const [selectedGenre, setSelectedGenre] = useState('');
  const [selectedDifficulty, setSelectedDifficulty] = useState('');

  return (
    <View style={styles.container}>
      <Text style={styles.heading}>Select Genre</Text>
      {genres.map((genre) => (
        <Pressable
          key={genre}
          style={styles.radioContainer}
          onPress={() => setSelectedGenre(genre)}
        >
          <View style={styles.outerCircle}>
            {selectedGenre === genre && <View style={styles.innerCircle} />}
          </View>
          <Text style={styles.label}>{genre}</Text>
        </Pressable>
      ))}

      <Text style={styles.heading}>Select Difficulty</Text>
      {difficulties.map((level) => (
        <Pressable
          key={level}
          style={styles.radioContainer}
          onPress={() => setSelectedDifficulty(level)}
        >
          <View style={styles.outerCircle}>
            {selectedDifficulty === level && <View style={styles.innerCircle} />}
          </View>
          <Text style={styles.label}>{level}</Text>
        </Pressable>
      ))}

      <Button
        title="Start Game"
        onPress={() =>
          navigation.navigate('Question', {
            genre: selectedGenre,
            difficulty: selectedDifficulty,
          })
        }
        disabled={!selectedGenre || !selectedDifficulty}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 24,
    flex: 1,
    backgroundColor: '#fff',
  },
  heading: {
    fontSize: 18,
    fontWeight: '600',
    marginVertical: 10,
  },
  radioContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: 6,
  },
  outerCircle: {
    height: 20,
    width: 20,
    borderRadius: 10,
    borderWidth: 2,
    borderColor: '#333',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 10,
  },
  innerCircle: {
    height: 10,
    width: 10,
    borderRadius: 5,
    backgroundColor: '#333',
  },
  label: {
    fontSize: 16,
  },
});

