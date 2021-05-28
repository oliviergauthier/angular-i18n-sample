"use strict";
const path = require("path");

const locales = ["en", "fr"];

exports.handler = (event, context, callback) => {
  const { request } = event.Records[0].cf;
  const headers = request.headers;
  
  console.log(JSON.stringify(event));
  if (!path.extname(request.uri)) {
    if (request.uri.startsWith("/fr/")) {
      handle(request, "fr", callback);
    } else if(request.uri.startsWith("/en/")) {
      handle(request, "en", callback);
    } else {
      redirect(headers, callback);
    }
  } else {
    if (request.uri == "/index.html") {
      redirect(headers, callback);
    } else {
      console.log(`Request Assets : $${request.uri}`);
      callback(null, request);
    }
  }
};

function getBestLocale(headers) {
  if (
    headers &&
    headers["accept-language"] &&
    headers["accept-language"].length > 0 &&
    headers["accept-language"][0].value
  ) {
    const acceptLanguage = headers["accept-language"][0].value;
    if (acceptLanguage.startsWith("en")) {
      return "en";
    }
  }
  return "fr";
}

function redirect(headers, callback) {
   const locale = getBestLocale(headers);
   const response = {
        status: "302",
        statusDescription: "Found",
        headers: {
          location: [
            {
              key: "Location",
              value: `https://${domain}/$${locale}/index.html`,
            },
          ],
        },
      };
      callback(null, response);
}

function handle(request, locale, callback) {
  console.log(`Request en uri : $${request.uri}`)
  request.uri = `/$${locale}/index.html`;
  callback(null, request);
}