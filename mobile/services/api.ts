import axios from 'axios';
import { Platform } from 'react-native';

// Android emulators need to use 10.0.2.2 to access host's localhost
// iOS simulators can use localhost directly
const baseURL = Platform.OS === 'android' 
  ? 'http://10.0.2.2:3000/api/v1'
  : 'http://localhost:3000/api/v1';

console.log(`API configured with baseURL: ${baseURL} for platform: ${Platform.OS}`);

const api = axios.create({
  baseURL,
  // Add timeout to prevent hanging requests
  timeout: 10000,
  // Add headers for better debugging
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  // Disable SSL certificate validation for development
  // This is needed for Android emulator connecting to localhost
  validateStatus: status => status >= 200 && status < 300
});

// Add request interceptor for logging
api.interceptors.request.use(
  config => {
    console.log(`Making ${config.method.toUpperCase()} request to: ${config.baseURL}${config.url}`);
    return config;
  },
  error => {
    console.error('Request error:', error);
    return Promise.reject(error);
  }
);

// Add response interceptor for logging
api.interceptors.response.use(
  response => {
    console.log(`Response from ${response.config.url}: Status ${response.status}`);
    return response;
  },
  error => {
    console.error('Response error:', error);
    if (error.response) {
      console.log('Error status:', error.response.status);
      console.log('Error data:', error.response.data);
    } else if (error.request) {
      console.log('No response received');
    }
    return Promise.reject(error);
  }
);

export default api;

