/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { Component } from 'react';
import { StyleSheet, Text, View, Button, Alert, requireNativeComponent } from 'react-native';

const Camera = requireNativeComponent("Camera");

export default class App extends Component {
  constructor(props) {
    super(props);
    this._onStatusChange = this._onStatusChange.bind(this);
    this.state = { bestGuess: "nothing", confidence: 0 }
  }

  _onStatusChange = e => {
    this.setState({ bestGuess: e.nativeEvent.bestGuess, confidence: e.nativeEvent.confidence })
  }

  render() {
    return (
      <View style={ styles.container }>        
        <Camera style={ styles.bottom } onStatusChange={ this._onStatusChange } />
        <View style={ styles.top }>
          <Text>State comes from iOS to JavaScript</Text>
          <Text>Current Best Guess is: { this.state.bestGuess }</Text>
          <Text>Current Confidence is: { this.state.confidence }</Text>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    borderWidth: 20,
    borderColor: '#FFFFFF',
  },
  top: {
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'transparent',
    borderColor: '#000000',
    borderWidth: 1,
  },
  bottom: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#FFFFFF',
    alignSelf: 'stretch',
  },
});