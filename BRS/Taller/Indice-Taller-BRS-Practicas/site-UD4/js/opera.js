document.addEventListener('DOMContentLoaded', function () {
    var userAgent = navigator.userAgent;
    if (userAgent.includes("OPR") || userAgent.includes("Opera")) {
        var articleElements = document.querySelectorAll('article');
        articleElements.forEach(function (element) {
            element.classList.add('opera-browser');
        });
    }
});

