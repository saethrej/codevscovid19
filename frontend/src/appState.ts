import { observable, action } from 'mobx'
import bind from 'bind-decorator'
import { LatLngTuple } from 'leaflet'
import { act } from 'react-dom/test-utils'

class AppState {
  @observable
  position: LatLngTuple = [0, 0]

  @bind
  @action
  async setLatLng() {
    const geo = navigator.geolocation
    if (geo) {
      await geo.getCurrentPosition(this.setPosition)
    }
  }

  @bind
  @action
  setPosition(position: Position) {
    this.position = [position.coords.latitude, position.coords.longitude]
    const req = new XMLHttpRequest()
    const pos = this.position
    const msg = JSON.stringify({ position: pos })
    console.log(msg)
    req.open('POST', 'http://localhost:8000')
    req.setRequestHeader('Content-type', 'application/json')
    req.onreadystatechange = (_event: Event) => {
      if (req.readyState === 4 && req.status === 200) {
        appState.drawHeatMaps()
      }
    }
    req.send(msg)
  }

  @bind
  @action
  drawHeatMaps() {
    console.log('drawn')
  }
}

export const appState = new AppState()
