//clear Stories in NYTIMES

  var stories = document.getElementsByClassName('collection');
  Array.prototype.forEach.call(stories, function (element, index) {
     console.log("hey" + element);
      var contents = element.innerHTML;
    if (contents.includes("Trump")) element.innerHTML = "";
  });
