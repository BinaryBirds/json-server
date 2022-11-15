function copySnippet(id) {
    const copyText = document.getElementById("example-code-" + id);
    copyText.select();
    copyText.setSelectionRange(0, 99999);
    navigator.clipboard.writeText(copyText.value);
    
    const tooltip = document.getElementById("copy-button-" + id);
    tooltip.innerHTML = "Copied!";

    setTimeout(() => {
        tooltip.innerHTML = "Copy";
    }, 1000);
}

function toggleElement(id) {
    // hide everything
//    const elements = document.getElementsByTagName("dl")
//    for (let i = 0; i < elements.length; i++) {
//        elements[i].style.display = "none";
//    }

    const x = document.getElementById(id);
    
    if (x.style.display == "block") {
        x.style.display = "none";
    }
    else {
        x.style.display = "block";
    }
}

function changeTab(event, tabId) {
    const tabParent = event.currentTarget.parentNode.parentNode;
    const tabs = tabParent.querySelectorAll(".tabcontent");
    // hide all tabs
    for (var i = 0; i < tabs.length; i++) {
        tabs[i].style.display = "none";
    }
    // hide deactivate all the buttons
    const buttons = tabParent.querySelectorAll(".tablinks");
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].classList.remove("active");
    }
    // display tab, activate current button
    tabParent.querySelector("#" + tabId).style.display = "block";
    event.currentTarget.classList.add("active");
}
// var activePaneId = anchorReference.getAttribute("href");
