
    var lastlink = "http://nytimes";


    document.body.innerHTML = document.body.innerHTML.replace(new RegExp("Donald J. Trump", "g"), "Daniel B. O'Sullivan");
    document.body.innerHTML = document.body.innerHTML.replace(new RegExp("Donald Trump", "g"), "Dan O'Sullivan");
    document.body.innerHTML = document.body.innerHTML.replace(new RegExp("Trump", "g"), "O'Sullivan");
     //$("a.profileLink").attr("href", "http://nytimes.com/");  //using jquery


//change names of links in facebook
    var anchors = document.querySelectorAll('a[class="profileLink"');
	Array.prototype.forEach.call(anchors, function (element, index) {
    element.innerText = "anonymous";//lastlink; // "http://stackoverflow.com";

});


//switch links in twitter
    var anchors = document.querySelectorAll('a[class="account-group js-account-group js-action-profile js-user-profile-link js-nav"');
	Array.prototype.forEach.call(anchors, function (element, index) {
    var link = element.href;
    element.href = lastlink; // "http://stackoverflow.com";
    lastlink = link;
});



