// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss';

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'phoenix_html';
import { Socket } from 'phoenix';
import topbar from 'topbar';
import { LiveSocket } from 'phoenix_live_view';

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');

async function initStream() {
  try {
    // Gets our local media from the browser and stores it as a const, stream.
    const stream = await navigator.mediaDevices.getUserMedia({
      audio: true,
      video: true,
      width: '1280',
    });
    // Stores our stream in the global constant, localStream.
    localStream = stream;
    // Sets our local video element to stream from the user's webcam (stream).
    document.getElementById('local-video').srcObject = stream;
  } catch (e) {
    console.log(e);
  }
}

let Hooks = {};
Hooks.JoinCall = {
  mounted() {
    // try {
    //   // Gets our local media from the browser and stores it as a const, stream.
    navigator.mediaDevices.getUserMedia({
      audio: true,
      video: true,
      width: '1280',
    });

    navigator.getUserMedia(
      {
        audio: true,
        video: true,
        width: '1280',
      },
      (localMediaStream) => {
        const video = document.getElementById('local-video');
        video.srcObject = localMediaStream;
        //video.src = window.URL.createObjectURL(localMediaStream);
      },
      (e) => {
        console.error(e);
      }
    );
  },
};

let liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' });
window.addEventListener('phx:page-loading-start', (info) => topbar.show());
window.addEventListener('phx:page-loading-stop', (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
