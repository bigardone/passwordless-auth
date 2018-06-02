import Elm from '../elm/src/Main.elm';

const elmDiv = document.getElementById('elm-main');

if (elmDiv) {
  Elm.Main.embed(elmDiv);
}
