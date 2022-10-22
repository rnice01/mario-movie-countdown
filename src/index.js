import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';
import { formatDistance } from 'date-fns'

const app = Elm.Main.init({
  node: document.getElementById('root')
})

const generateRandom = max => {
  app.ports.receiveRandom.send(Math.floor(Math.random() * max))
}

const countdownTo = date => {
  let distance = new Date(date).getTime() - new Date().getTime()

  // Time calculations for days, hours, minutes and seconds
  let days = Math.floor(distance / (1000 * 60 * 60 * 24));
  let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  let seconds = Math.floor((distance % (1000 * 60)) / 1000);
  app.ports.receiveCountDown.send(`${days}d  ${hours}h ${minutes}m ${seconds}s`)
}

app.ports.generateRandom.subscribe(generateRandom)
app.ports.countdownTo.subscribe(countdownTo)

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

