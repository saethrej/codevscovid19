import React from 'react'
import './App.css'
import { bind } from 'bind-decorator'
import { observer } from 'mobx-react'
import 'reflect-metadata'
// import { StylesProvider } from '@material-ui/core/styles'
import logo from './logo.svg'
import './App.css'
import { observable, action } from 'mobx'

@observer
class App extends React.Component {
  @observable
  text: string = 'bla'
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.js</code> and save to reload.
          </p>
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn asdsad
            {this.text}
          </a>
          <button onClick={this.try}> Connect</button>
        </header>
      </div>
    )
  }

  @bind
  try() {
    this.test(this.httpResp)
  }
  test(httpResp: (bla: string) => void) {
    const xhttp = new XMLHttpRequest()
    xhttp.onreadystatechange = function(_e: Event) {
      if (xhttp.readyState === 4 && xhttp.status === 200) {
        httpResp('ble')
      } else {
        httpResp('blun')
      }
    }

    xhttp.open('GET', 'www.ch.ch', true)
    xhttp.send()
  }

  @bind
  @action
  httpResp(bla: string) {
    this.text = bla
  }
}

export default App
