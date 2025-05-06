import React, { useState, useEffect } from 'react';
import { View, Text, Button, StyleSheet, ActivityIndicator } from 'react-native';
import api from '../services/api';

export default function QuestionScreen({ route, navigation }) {
  const { genre, difficulty } = route.params;
  const [questionData, setQuestionData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchQuestion = async () => {
      try {
        setLoading(true);
        const response = await api.get('/trivia/question', {
          params: { genre, difficulty }
        });
        setQuestionData(response.data);
        setLoading(false);
      } catch (err) {
        console.error('Error fetching question:', err);
        setError('Failed to load question. Please try again.');
        setLoading(false);
      }
    };

    fetchQuestion();
  }, [genre, difficulty]);

  const validateAnswer = async (selected) => {
    if (!questionData) return;
    
    try {
      const res = await api.post('/trivia/validate', {
        selected_answer: selected,
        correct_answer: questionData.correct_answer
      });

      alert(res.data.correct ? 'Correct!' : 'Wrong!');
      
      // Optionally navigate back or to a results screen
      // navigation.goBack();
    } catch (err) {
      console.error('Error validating answer:', err);
      alert('Failed to validate answer. Please try again.');
    }
  };

  if (loading) {
    return (
      <View style={styles.centered}>
        <ActivityIndicator size="large" color="#0000ff" />
        <Text style={styles.loadingText}>Loading question...</Text>
      </View>
    );
  }

  if (error) {
    return (
      <View style={styles.centered}>
        <Text style={styles.errorText}>{error}</Text>
        <Button title="Try Again" onPress={() => navigation.goBack()} />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {questionData ? (
        <>
          <Text style={styles.question}>{questionData.question}</Text>
          {questionData.answers.map((ans) => (
            <Button 
              key={ans} 
              title={ans} 
              onPress={() => validateAnswer(ans)}
              style={styles.answerButton} 
            />
          ))}
        </>
      ) : (
        <Text style={styles.errorText}>No question data available</Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 20,
    flex: 1,
    backgroundColor: '#fff',
  },
  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  question: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 20,
    textAlign: 'center',
  },
  answerButton: {
    marginVertical: 8,
  },
  loadingText: {
    marginTop: 10,
    fontSize: 16,
  },
  errorText: {
    color: 'red',
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 20,
  }
});

