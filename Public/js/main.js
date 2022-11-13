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

function openCity(evt, cityName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(cityName).style.display = "block";
    evt.currentTarget.className += " active";
}
