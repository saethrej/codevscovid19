import React from 'react'
import './App.css'
import { bind } from 'bind-decorator'
import { observer } from 'mobx-react'
import 'reflect-metadata'
import { Map, Marker, Popup, TileLayer } from 'react-leaflet'
// import { StylesProvider } from '@material-ui/core/styles'
import logo from './logo.svg'
import './App.css'
import { observable, action } from 'mobx'
import { appState } from './appState'

@observer
class MapDrawer extends React.Component {
  componentDidMount() {
    appState.setLatLng().catch((error: Error) => console.log(error.message))
  }
  render() {
    return (
      <Map center={appState.position} zoom={13}>
        <TileLayer
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
        />
        <Marker position={appState.position}>
          <Popup>
            A pretty CSS3 popup.
            <br />
            Easily customizable.
          </Popup>
        </Marker>
      </Map>
    )
  }
}

export default MapDrawer
