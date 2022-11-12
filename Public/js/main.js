function copySnippet(id) {
    const copyText = document.getElementById("snippet-code-" + id);
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
