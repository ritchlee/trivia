import React from 'react';
import { View, Text, Button } from 'react-native';
import api from '../services/api';

export default function QuestionScreen({ route }) {
  const { questionData } = route.params;

  const validateAnswer = async (selected: string) => {
    const res = await api.post('/trivia/validate', {
      selected_answer: selected,
      correct_answer: questionData.correct_answer
    });

    alert(res.data.correct ? 'Correct!' : 'Wrong!');
  };

  return (
    <View>
      <Text>{questionData.question}</Text>
      {questionData.answers.map((ans: string) => (
        <Button key={ans} title={ans} onPress={() => validateAnswer(ans)} />
      ))}
    </View>
  );
}

