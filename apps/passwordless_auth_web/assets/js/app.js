import Elm from '../elm/src/Main.elm';
import css from '../css/app.css';

const elmDiv = document.getElementById('elm-main');

let token = window.token;
const socketUrl = window.socketUrl;

if (token === '' || token == null) token = window.localStorage.getItem('token');

if (elmDiv) {
  const app = Elm.Main.embed(elmDiv, { token, socketUrl });

  app.ports.saveToken.subscribe((token) => {
    window.localStorage.setItem('token', token);
  });
}
