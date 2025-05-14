import axios from 'axios';
import { Platform } from 'react-native';

// Android emulators need to use 10.0.2.2 to access host's localhost
// iOS simulators can use localhost directly
const baseURL = Platform.OS === 'android' 
  ? 'http://10.0.2.2:3000/api/v1'
  : 'http://localhost:3000/api/v1';

const api = axios.create({
  baseURL,
});

export default api;

