  function getCurrentTab(tempUrl) {
 chrome.tabs.query({ active: true, lastFocusedWindow: true }, tabs => {
     let url = tabs[0].url;
     tempUrl = url;
     console.log(url);
     console.log("SCRIPT DONE");
        return url;
 });
  }

