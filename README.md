# README

Well, I've spent a lot of time on this assignment, faced lots of issues from basics errors with setup to simulating browser-like request for url opener because of the site blockage.

Unfortunately, the twitter:image meta tag or other analogue for the image was not found on the page. It's possible that the page doesn't use this tag for some reason.

The price is not displayed in plain HTML through standard selectors. It's most likely loaded dynamically using JavaScript, so I can't extract it using standard Nokogiri without using JavaScript rendering tools like Selenium or Puppeteer. 

But the information I were looking for in `keywords` is actually in a meta tag with the name="description" attribute. So this is the only area where I have succeeded

Being honest, it doesn't work and require overhaul. But hey, I'll show you at least what I've done.

* Ruby version

I've used version 3.0.0

