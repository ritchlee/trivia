module.exports = {
  preset: 'react-native',
  transform: {
    "^.+\\.(ts|tsx)$": "babel-jest",
  },
  transformIgnorePatterns: [
    "node_modules/(?!react-native|@react-native|@react-native-community|@react-navigation)",
  ],
  moduleFileExtensions: ["ts", "tsx", "js", "jsx", "json", "node"],
};
