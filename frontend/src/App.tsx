import React from 'react'
import './App.css'
import { bind } from 'bind-decorator'
import { observer } from 'mobx-react'
import 'reflect-metadata'
// import { StylesProvider } from '@material-ui/core/styles'
import logo from './logo.svg'
import './App.css'
import { observable, action } from 'mobx'
import { appState } from './appState'
import { LatLngTuple } from 'leaflet'
import MapDrawer from './MapDrawer'

@observer
class App extends React.Component {
  render() {
    return (
      <div className="App">
        <MapDrawer></MapDrawer>
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
    return
  }
}

export default App
