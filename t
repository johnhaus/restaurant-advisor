[1mdiff --git a/app/controllers/restaurants_controller.rb b/app/controllers/restaurants_controller.rb[m
[1mindex a57cfa0..e8ae17b 100644[m
[1m--- a/app/controllers/restaurants_controller.rb[m
[1m+++ b/app/controllers/restaurants_controller.rb[m
[36m@@ -12,6 +12,14 @@[m [mclass RestaurantsController < ApplicationController[m
 [m
   def index[m
     @restaurants = policy_scope(Restaurant)[m
[32m+[m[32m    @restaurants = Restaurant.where.not(latitude: nil, longitude: nil)[m
[32m+[m
[32m+[m[32m    @markers = @restaurants.map do |restaurant|[m
[32m+[m[32m      {[m
[32m+[m[32m        lng: restaurant.longitude,[m
[32m+[m[32m        lat: restaurant.latitude[m
[32m+[m[32m      }[m
[32m+[m[32m    end[m
   end[m
 [m
   def show[m
[1mdiff --git a/app/javascript/packs/application.js b/app/javascript/packs/application.js[m
[1mindex d1c0699..45e5b7a 100644[m
[1m--- a/app/javascript/packs/application.js[m
[1m+++ b/app/javascript/packs/application.js[m
[36m@@ -11,3 +11,9 @@[m [mimport 'bootstrap';[m
 [m
 import { loadDynamicBannerText } from '../components/banner';[m
 loadDynamicBannerText();[m
[32m+[m
[32m+[m[32mimport 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout![m
[32m+[m
[32m+[m[32mimport { initMapbox } from '../plugins/init_mapbox';[m
[32m+[m
[32m+[m[32minitMapbox();[m
[1mdiff --git a/app/models/restaurant.rb b/app/models/restaurant.rb[m
[1mindex c311240..416293e 100644[m
[1m--- a/app/models/restaurant.rb[m
[1m+++ b/app/models/restaurant.rb[m
[36m@@ -8,7 +8,7 @@[m [mclass Restaurant < ApplicationRecord[m
   validates :rating, presence: true, inclusion: { in: [1,2,3,4,5], allow_nil: false}[m
 [m
   geocoded_by :city[m
[31m-  after_validation :geocode, if: :city_changed?[m
[32m+[m[32m  after_validation :geocode, if: :will_save_change_to_city?[m
 [m
   mount_uploader :photo, PhotoUploader[m
   mount_uploader :photo_of_the_chef, PhotoUploader[m
[1mdiff --git a/app/views/restaurants/index.html.erb b/app/views/restaurants/index.html.erb[m
[1mindex e4165e0..3516978 100644[m
[1m--- a/app/views/restaurants/index.html.erb[m
[1m+++ b/app/views/restaurants/index.html.erb[m
[36m@@ -2,12 +2,21 @@[m
   <div class="row">[m
     <h1 class="page-padding all-restaurants">All Restaurants</h1>[m
     <div class="typed-padding">[m
[31m-    <h2 class="all-restaurants">Restaurant Advisor. <span id="banner-typed-text"></span></h2>[m
[32m+[m[32m      <h2 class="all-restaurants">Restaurant Advisor. <span id="banner-typed-text"></span></h2>[m
     </div>[m
[32m+[m[32m    <div>[m
     <% @restaurants.each do |r| %>[m
[31m-    <div class="col-xs-10 col-sm-4">[m
[31m-      <%= render "card", restaurant: r %>[m
[31m-    </div>[m
[32m+[m[32m      <div class="col-xs-10 col-sm-4">[m
[32m+[m[32m        <%= render "card", restaurant: r %>[m
[32m+[m[32m      </div>[m
     <% end %>[m
[32m+[m[32m    </div>[m
[32m+[m[32m    <div[m
[32m+[m[32m      id="map"[m
[32m+[m[32m      style="width: 100%;[m
[32m+[m[32m      height: 600px;"[m
[32m+[m[32m      data-markers="<%= @markers.to_json %>"[m
[32m+[m[32m      data-mapbox-api-key="<%= ENV['MAPBOX_API_KEY'] %>"[m
[32m+[m[32m    ></div>[m
   </div>[m
 </div>[m
[1mdiff --git a/package.json b/package.json[m
[1mindex 5341846..42509ca 100644[m
[1m--- a/package.json[m
[1m+++ b/package.json[m
[36m@@ -5,6 +5,7 @@[m
     "@rails/webpacker": "3.5",[m
     "bootstrap": "4.1.2",[m
     "jquery": "^3.3.1",[m
[32m+[m[32m    "mapbox-gl": "^0.52.0",[m
     "popper.js": "^1.14.6",[m
     "typed.js": "^2.0.9"[m
   },[m
[1mdiff --git a/yarn.lock b/yarn.lock[m
[1mindex 477f12c..38a102b 100644[m
[1m--- a/yarn.lock[m
[1m+++ b/yarn.lock[m
[36m@@ -2,6 +2,55 @@[m
 # yarn lockfile v1[m
 [m
 [m
[32m+[m[32m"@mapbox/geojson-area@0.2.2":[m
[32m+[m[32m  version "0.2.2"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/@mapbox/geojson-area/-/geojson-area-0.2.2.tgz#18d7814aa36bf23fbbcc379f8e26a22927debf10"[m
[32m+[m[32m  integrity sha1-GNeBSqNr8j+7zDefjiaiKSfevxA=[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    wgs84 "0.0.0"[m
[32m+[m
[32m+[m[32m"@mapbox/geojson-types@^1.0.2":[m
[32m+[m[32m  version "1.0.2"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/@mapbox/geojson-types/-/geojson-types-1.0.2.tgz#9aecf642cb00eab1080a57c4f949a65b4a5846d6"[m
[32m+[m[32m  integrity sha512-e9EBqHHv3EORHrSfbR9DqecPNn+AmuAoQxV6aL8Xu30bJMJR1o8PZLZzpk1Wq7/NfCbuhmakHTPYRhoqLsXRnw==[m
[32m+[m
[32m+[m[32m"@mapbox/jsonlint-lines-primitives@^2.0.2":[m
[32m+[m[32m  version "2.0.2"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/@mapbox/jsonlint-lines-primitives/-/jsonlint-lines-primitives-2.0.2.tgz#ce56e539f83552b58d10d672ea4d6fc9adc7b234"[m
[32m+[m[32m  integrity sha1-zlblOfg1UrWNENZy6k1vya3HsjQ=[m
[32m+[m
[32m+[m[32m"@mapbox/mapbox-gl-supported@^1.4.0":[m
[32m+[m[32m  version "1.4.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/@mapbox/mapbox-gl-supported/-/mapbox-gl-supported-1.4.0.tgz#36946b22944fe2cfa43cfafd5ef36fdb54a069e4"[m
[32m+[m[32m  integrity sha512-ZD0Io4XK+/vU/4zpANjOtdWfVszAgnaMPsGR6LKsWh4kLIEv9qoobTVmJPPuwuM+ZI2b3BlZ6DYw1XHVmv6YTA==[m
[32m+[m
[32m+[m[32m"@mapbox/point-geometry@0.1.0", "@mapbox/point-geometry@^0.1.0", "@mapbox/point-geometry@~0.1.0":[m
[32m+[m[32m  version "0.1.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/@mapbox/point-geometry/-/point-geometry-0.1.0.tgz#8a83f9335c7860effa2eeeca254332aa0aeed8f2"[m
[32m+[m[32m  integrity sha1-ioP5M1x4YO/6Lu7KJUMyqgru2PI=[m
[32m+[m
[32m+[m[32m"@mapbox/tiny-sdf@^1.1.0":[m
[32m+[m[32m  version "1.1.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/@mapbox/tiny-sdf/-/tiny-sdf-1.1.0.tgz#b0b8f5c22005e6ddb838f421ffd257c1f74f9a20"[m
[32m+[m[32m  integrity sha512-dnhyk8X2BkDRWImgHILYAGgo+kuciNYX30CUKj/Qd5eNjh54OWM/mdOS/PWsPeN+3abtN+QDGYM4G220ynVJKA==[m
[32m+[m
[32m+[m[32m"@mapbox/unitbezier@^0.0.0":[m
[32m+[m[32m  version "0.0.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/@mapbox/unitbezier/-/unitbezier-0.0.0.tgz#15651bd553a67b8581fb398810c98ad86a34524e"[m
[32m+[m[32m  integrity sha1-FWUb1VOme4WB+zmIEMmK2Go0Uk4=[m
[32m+[m
[32m+[m[32m"@mapbox/vector-tile@^1.3.1":[m
[32m+[m[32m  version "1.3.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/@mapbox/vector-tile/-/vector-tile-1.3.1.tgz#d3a74c90402d06e89ec66de49ec817ff53409666"[m
[32m+[m[32m  integrity sha512-MCEddb8u44/xfQ3oD+Srl/tNcQoqTw3goGk2oLsrFxOTc3dUp+kAnby3PvAeeBYSMSjSPD1nd1AJA6W49WnoUw==[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    "@mapbox/point-geometry" "~0.1.0"[m
[32m+[m
[32m+[m[32m"@mapbox/whoots-js@^3.1.0":[m
[32m+[m[32m  version "3.1.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/@mapbox/whoots-js/-/whoots-js-3.1.0.tgz#497c67a1cef50d1a2459ba60f315e448d2ad87fe"[m
[32m+[m[32m  integrity sha512-Es6WcD0nO5l+2BOQS4uLfNPYQaNDfbot3X1XUoloz+x0mPDS3eeORZJl06HXjwBG1fOGwCRnzK88LMdxKRrd6Q==[m
[32m+[m
 "@rails/webpacker@3.5":[m
   version "3.5.5"[m
   resolved "https://registry.yarnpkg.com/@rails/webpacker/-/webpacker-3.5.5.tgz#8911c66bcefc8bc6b91270e92f0d39e3c2d43116"[m
[36m@@ -144,6 +193,11 @@[m [mansi-styles@^3.2.1:[m
   dependencies:[m
     color-convert "^1.9.0"[m
 [m
[32m+[m[32mansicolors@~0.2.1:[m
[32m+[m[32m  version "0.2.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/ansicolors/-/ansicolors-0.2.1.tgz#be089599097b74a5c9c4a84a0cdbcdb62bd87aef"[m
[32m+[m[32m  integrity sha1-vgiVmQl7dKXJxKhKDNvNtivYeu8=[m
[32m+[m
 anymatch@^2.0.0:[m
   version "2.0.0"[m
   resolved "https://registry.yarnpkg.com/anymatch/-/anymatch-2.0.0.tgz#bcb24b4f37934d9aa7ac17b4adaf89e7c76ef2eb"[m
[36m@@ -1228,6 +1282,14 @@[m [mcaniuse-lite@^1.0.0, caniuse-lite@^1.0.30000792, caniuse-lite@^1.0.30000805, can[m
   resolved "https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30000909.tgz#697e8f447ca5f758e7c6cef39ec429ce18b908d3"[m
   integrity sha512-4Ix9ArKpo3s/dLGVn/el9SAk6Vn2kGhg8XeE4eRTsGEsmm9RnTkwnBsVZs7p4wA8gB+nsgP36vZWYbG8a4nYrg==[m
 [m
[32m+[m[32mcardinal@~0.4.2:[m
[32m+[m[32m  version "0.4.4"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/cardinal/-/cardinal-0.4.4.tgz#ca5bb68a5b511b90fe93b9acea49bdee5c32bfe2"[m
[32m+[m[32m  integrity sha1-ylu2iltRG5D+k7ms6km97lwyv+I=[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    ansicolors "~0.2.1"[m
[32m+[m[32m    redeyed "~0.4.0"[m
[32m+[m
 case-sensitive-paths-webpack-plugin@^2.1.2:[m
   version "2.1.2"[m
   resolved "https://registry.yarnpkg.com/case-sensitive-paths-webpack-plugin/-/case-sensitive-paths-webpack-plugin-2.1.2.tgz#c899b52175763689224571dad778742e133f0192"[m
[36m@@ -1512,7 +1574,7 @@[m [mconcat-map@0.0.1:[m
   resolved "https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz#d8a96bd77fd68df7793a73036a3ba0d5405d477b"[m
   integrity sha1-2Klr13/Wjfd5OnMDajug1UBdR3s=[m
 [m
[31m-concat-stream@^1.5.0:[m
[32m+[m[32mconcat-stream@^1.5.0, concat-stream@~1.6.0:[m
   version "1.6.2"[m
   resolved "https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz#904bdf194cd3122fc675c77fc4ac3d4ff0fd1a34"[m
   integrity sha512-27HBghJxjiZtIk3Ycvn/4kbJk/1uZuJFfuPEns6LaEvpvG1f0hTea8lilrouyo9mVc2GWdcEZ8OLoGmSADlrCw==[m
[36m@@ -1733,6 +1795,11 @@[m [mcss-unit-converter@^1.1.1:[m
   resolved "https://registry.yarnpkg.com/css-unit-converter/-/css-unit-converter-1.1.1.tgz#d9b9281adcfd8ced935bdbaba83786897f64e996"[m
   integrity sha1-2bkoGtz9jO2TW9urqDeGiX9k6ZY=[m
 [m
[32m+[m[32mcsscolorparser@~1.0.2:[m
[32m+[m[32m  version "1.0.3"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/csscolorparser/-/csscolorparser-1.0.3.tgz#b34f391eea4da8f3e98231e2ccd8df9c041f171b"[m
[32m+[m[32m  integrity sha1-s085HupNqPPpgjHizNjfnAQfFxs=[m
[32m+[m
 cssesc@^0.1.0:[m
   version "0.1.0"[m
   resolved "https://registry.yarnpkg.com/cssesc/-/cssesc-0.1.0.tgz#c814903e45623371a0477b40109aaafbeeaddbb4"[m
[36m@@ -2006,6 +2073,11 @@[m [mduplexify@^3.4.2, duplexify@^3.6.0:[m
     readable-stream "^2.0.0"[m
     stream-shift "^1.0.0"[m
 [m
[32m+[m[32mearcut@^2.1.3:[m
[32m+[m[32m  version "2.1.4"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/earcut/-/earcut-2.1.4.tgz#6b161f89bfe4bb08576b9e8af165e1477d6a1c02"[m
[32m+[m[32m  integrity sha512-ttRjmPD5oaTtXOoxhFp9aZvMB14kBjapYaiBuzBB1elOgSLU9P2Ev86G2OClBg+uspUXERsIzXKpUWweH2K4Xg==[m
[32m+[m
 ecc-jsbn@~0.1.1:[m
   version "0.1.2"[m
   resolved "https://registry.yarnpkg.com/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz#3a83a904e54353287874c564b7549386849a98c9"[m
[36m@@ -2157,6 +2229,11 @@[m [mescope@^3.6.0:[m
     esrecurse "^4.1.0"[m
     estraverse "^4.1.1"[m
 [m
[32m+[m[32mesm@^3.0.84:[m
[32m+[m[32m  version "3.1.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/esm/-/esm-3.1.1.tgz#810d1144522547801a58a8ea01d6566d61578223"[m
[32m+[m[32m  integrity sha512-Md2pR4IbR37UqubbgbA4+wiBorOEFB05Oo+g4WJW7W2ajiOhUfjZt77NzzCoQdrCb40GdKcflitm+XHDF053OQ==[m
[32m+[m
 esprima@^2.6.0:[m
   version "2.7.3"[m
   resolved "https://registry.yarnpkg.com/esprima/-/esprima-2.7.3.tgz#96e3b70d5779f6ad49cd032673d1c312767ba581"[m
[36m@@ -2167,6 +2244,11 @@[m [mesprima@^4.0.0:[m
   resolved "https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz#13b04cdb3e6c5d19df91ab6987a8695619b0aa71"[m
   integrity sha512-eGuFFw7Upda+g4p+QHvnW0RyTX/SVeJBDM/gCtMARO0cLuT2HcEKnTPvhjV6aGeqrCB/sbNop0Kszm0jsaWU4A==[m
 [m
[32m+[m[32mesprima@~1.0.4:[m
[32m+[m[32m  version "1.0.4"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/esprima/-/esprima-1.0.4.tgz#9f557e08fc3b4d26ece9dd34f8fbf476b62585ad"[m
[32m+[m[32m  integrity sha1-n1V+CPw7TSbs6d00+Pv0drYlha0=[m
[32m+[m
 esrecurse@^4.1.0:[m
   version "4.2.1"[m
   resolved "https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.2.1.tgz#007a3b9fdbc2b3bb87e4879ea19c92fdbd3942cf"[m
[36m@@ -2274,6 +2356,11 @@[m [mexpand-brackets@^2.1.4:[m
     snapdragon "^0.8.1"[m
     to-regex "^3.0.1"[m
 [m
[32m+[m[32mexpect.js@~0.2.0:[m
[32m+[m[32m  version "0.2.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/expect.js/-/expect.js-0.2.0.tgz#1028533d2c1c363f74a6796ff57ec0520ded2be1"[m
[32m+[m[32m  integrity sha1-EChTPSwcNj90pnlv9X7AUg3tK+E=[m
[32m+[m
 express@^4.16.2:[m
   version "4.16.4"[m
   resolved "https://registry.yarnpkg.com/express/-/express-4.16.4.tgz#fddef61926109e24c515ea97fd2f1bdbf62df12e"[m
[36m@@ -2613,6 +2700,21 @@[m [mgaze@^1.0.0:[m
   dependencies:[m
     globule "^1.0.0"[m
 [m
[32m+[m[32mgeojson-rewind@^0.3.0:[m
[32m+[m[32m  version "0.3.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/geojson-rewind/-/geojson-rewind-0.3.1.tgz#22240797c847cc2f0c1d313e4aa0c915afa7f29d"[m
[32m+[m[32m  integrity sha1-IiQHl8hHzC8MHTE+SqDJFa+n8p0=[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    "@mapbox/geojson-area" "0.2.2"[m
[32m+[m[32m    concat-stream "~1.6.0"[m
[32m+[m[32m    minimist "1.2.0"[m
[32m+[m[32m    sharkdown "^0.1.0"[m
[32m+[m
[32m+[m[32mgeojson-vt@^3.2.1:[m
[32m+[m[32m  version "3.2.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/geojson-vt/-/geojson-vt-3.2.1.tgz#f8adb614d2c1d3f6ee7c4265cad4bbf3ad60c8b7"[m
[32m+[m[32m  integrity sha512-EvGQQi/zPrDA6zr6BnJD/YhwAkBP8nnJ9emh3EnHQKVMfg/MRVtPbMYdgVy/IaEmn4UfagD2a6fafPDL5hbtwg==[m
[32m+[m
 get-caller-file@^1.0.1:[m
   version "1.0.3"[m
   resolved "https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-1.0.3.tgz#f978fa4c90d1dfe7ff2d6beda2a515e713bdcf4a"[m
[36m@@ -2647,6 +2749,11 @@[m [mgetpass@^0.1.1:[m
   dependencies:[m
     assert-plus "^1.0.0"[m
 [m
[32m+[m[32mgl-matrix@^2.6.1:[m
[32m+[m[32m  version "2.8.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/gl-matrix/-/gl-matrix-2.8.1.tgz#1c7873448eac61d2cd25803a074e837bd42581a3"[m
[32m+[m[32m  integrity sha512-0YCjVpE3pS5XWlN3J4X7AiAx65+nqAI54LndtVFnQZB6G/FVLkZH8y8V6R3cIoOQR4pUdfwQGd1iwyoXHJ4Qfw==[m
[32m+[m
 glob-parent@^3.1.0:[m
   version "3.1.0"[m
   resolved "https://registry.yarnpkg.com/glob-parent/-/glob-parent-3.1.0.tgz#9e6af6299d8d3bd2bd40430832bd113df906c5ae"[m
[36m@@ -2697,6 +2804,11 @@[m [mgraceful-fs@^4.1.11, graceful-fs@^4.1.2, graceful-fs@^4.1.6, graceful-fs@^4.1.9:[m
   resolved "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.1.15.tgz#ffb703e1066e8a0eeaa4c8b80ba9253eeefbfb00"[m
   integrity sha512-6uHUhOPEBgQ24HM+r6b/QwWfZq+yiFcipKFrOFiBEnWdy5sdzYoi+pJeQaPI5qOLRFqWmAXUPQNsielzdLoecA==[m
 [m
[32m+[m[32mgrid-index@^1.0.0:[m
[32m+[m[32m  version "1.1.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/grid-index/-/grid-index-1.1.0.tgz#97f8221edec1026c8377b86446a7c71e79522ea7"[m
[32m+[m[32m  integrity sha512-HZRwumpOGUrHyxO5bqKZL0B0GlUpwtCAzZ42sgxUPniu33R1LSFH5yrIcBCHjkctCAh3mtWKcKd9J4vDDdeVHA==[m
[32m+[m
 handle-thing@^2.0.0:[m
   version "2.0.0"[m
   resolved "https://registry.yarnpkg.com/handle-thing/-/handle-thing-2.0.0.tgz#0e039695ff50c93fc288557d696f3c1dc6776754"[m
[36m@@ -2917,7 +3029,7 @@[m [micss-utils@^2.1.0:[m
   dependencies:[m
     postcss "^6.0.1"[m
 [m
[31m-ieee754@^1.1.4:[m
[32m+[m[32mieee754@^1.1.4, ieee754@^1.1.6:[m
   version "1.1.12"[m
   resolved "https://registry.yarnpkg.com/ieee754/-/ieee754-1.1.12.tgz#50bf24e5b9c8bb98af4964c941cdb0918da7b60b"[m
   integrity sha512-GguP+DRY+pJ3soyIiGPTvdiVXjZ+DbXOxGpXn3eMvNW4x4irjqXm4wHKscC+TfxSJ0yw/S1F24tqdMNsMZTiLA==[m
[36m@@ -3261,6 +3373,11 @@[m [mis-wsl@^1.1.0:[m
   resolved "https://registry.yarnpkg.com/is-wsl/-/is-wsl-1.1.0.tgz#1f16e4aa22b04d1336b66188a66af3c600c3a66d"[m
   integrity sha1-HxbkqiKwTRM2tmGIpmrzxgDDpm0=[m
 [m
[32m+[m[32misarray@0.0.1:[m
[32m+[m[32m  version "0.0.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz#8a18acfca9a8f4177e09abfc6038939b05d1eedf"[m
[32m+[m[32m  integrity sha1-ihis/Kmo9Bd+Cav8YDiTmwXR7t8=[m
[32m+[m
 isarray@1.0.0, isarray@^1.0.0, isarray@~1.0.0:[m
   version "1.0.0"[m
   resolved "https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz#bb935d48582cba168c06834957a54a3e07124f11"[m
[36m@@ -3401,6 +3518,11 @@[m [mjsprim@^1.2.2:[m
     json-schema "0.2.3"[m
     verror "1.10.0"[m
 [m
[32m+[m[32mkdbush@^3.0.0:[m
[32m+[m[32m  version "3.0.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/kdbush/-/kdbush-3.0.0.tgz#f8484794d47004cc2d85ed3a79353dbe0abc2bf0"[m
[32m+[m[32m  integrity sha512-hRkd6/XW4HTsA9vjVpY9tuXJYLSlelnkTmVFu4M9/7MIYQtFcHpbugAU7UbOfjOiVSVYl2fqgBuJ32JUmRo5Ew==[m
[32m+[m
 killable@^1.0.0:[m
   version "1.0.1"[m
   resolved "https://registry.yarnpkg.com/killable/-/killable-1.0.1.tgz#4c8ce441187a061c7474fb87ca08e2a638194892"[m
[36m@@ -3644,6 +3766,36 @@[m [mmap-visit@^1.0.0:[m
   dependencies:[m
     object-visit "^1.0.0"[m
 [m
[32m+[m[32mmapbox-gl@^0.52.0:[m
[32m+[m[32m  version "0.52.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/mapbox-gl/-/mapbox-gl-0.52.0.tgz#a43b61caa339ae28e43c87ecfbe9ce4032795859"[m
[32m+[m[32m  integrity sha512-jiZMGI7LjBNiSwYpFA3drzbZXrgEGERGJRpNS95t5BLZoc8Z+ggOOI1Fz2X+zLlh1j32iNDtf4j6En+caWwYiQ==[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    "@mapbox/geojson-types" "^1.0.2"[m
[32m+[m[32m    "@mapbox/jsonlint-lines-primitives" "^2.0.2"[m
[32m+[m[32m    "@mapbox/mapbox-gl-supported" "^1.4.0"[m
[32m+[m[32m    "@mapbox/point-geometry" "^0.1.0"[m
[32m+[m[32m    "@mapbox/tiny-sdf" "^1.1.0"[m
[32m+[m[32m    "@mapbox/unitbezier" "^0.0.0"[m
[32m+[m[32m    "@mapbox/vector-tile" "^1.3.1"[m
[32m+[m[32m    "@mapbox/whoots-js" "^3.1.0"[m
[32m+[m[32m    csscolorparser "~1.0.2"[m
[32m+[m[32m    earcut "^2.1.3"[m
[32m+[m[32m    esm "^3.0.84"[m
[32m+[m[32m    geojson-rewind "^0.3.0"[m
[32m+[m[32m    geojson-vt "^3.2.1"[m
[32m+[m[32m    gl-matrix "^2.6.1"[m
[32m+[m[32m    grid-index "^1.0.0"[m
[32m+[m[32m    minimist "0.0.8"[m
[32m+[m[32m    murmurhash-js "^1.0.0"[m
[32m+[m[32m    pbf "^3.0.5"[m
[32m+[m[32m    potpack "^1.0.1"[m
[32m+[m[32m    quickselect "^1.0.0"[m
[32m+[m[32m    rw "^1.3.3"[m
[32m+[m[32m    supercluster "^5.0.0"[m
[32m+[m[32m    tinyqueue "^1.1.0"[m
[32m+[m[32m    vt-pbf "^3.0.1"[m
[32m+[m
 math-expression-evaluator@^1.2.14:[m
   version "1.2.17"[m
   resolved "https://registry.yarnpkg.com/math-expression-evaluator/-/math-expression-evaluator-1.2.17.tgz#de819fdbcd84dccd8fae59c6aeb79615b9d266ac"[m
[36m@@ -3784,12 +3936,17 @@[m [mminimatch@^3.0.4, minimatch@~3.0.2:[m
   dependencies:[m
     brace-expansion "^1.1.7"[m
 [m
[32m+[m[32mminimist@0.0.5:[m
[32m+[m[32m  version "0.0.5"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/minimist/-/minimist-0.0.5.tgz#d7aa327bcecf518f9106ac6b8f003fa3bcea8566"[m
[32m+[m[32m  integrity sha1-16oye87PUY+RBqxrjwA/o7zqhWY=[m
[32m+[m
 minimist@0.0.8:[m
   version "0.0.8"[m
   resolved "https://registry.yarnpkg.com/minimist/-/minimist-0.0.8.tgz#857fcabfc3397d2625b8228262e86aa7a011b05d"[m
   integrity sha1-hX/Kv8M5fSYluCKCYuhqp6ARsF0=[m
 [m
[31m-minimist@^1.1.3, minimist@^1.2.0:[m
[32m+[m[32mminimist@1.2.0, minimist@^1.1.3, minimist@^1.2.0:[m
   version "1.2.0"[m
   resolved "https://registry.yarnpkg.com/minimist/-/minimist-1.2.0.tgz#a35008b20f41383eec1fb914f4cd5df79a264284"[m
   integrity sha1-o1AIsg9BOD7sH7kU9M1d95omQoQ=[m
[36m@@ -3883,6 +4040,11 @@[m [mmulticast-dns@^6.0.1:[m
     dns-packet "^1.3.1"[m
     thunky "^1.0.2"[m
 [m
[32m+[m[32mmurmurhash-js@^1.0.0:[m
[32m+[m[32m  version "1.0.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/murmurhash-js/-/murmurhash-js-1.0.0.tgz#b06278e21fc6c37fa5313732b0412bcb6ae15f51"[m
[32m+[m[32m  integrity sha1-sGJ44h/Gw3+lMTcysEEry2rhX1E=[m
[32m+[m
 nan@^2.10.0, nan@^2.9.2:[m
   version "2.11.1"[m
   resolved "https://registry.yarnpkg.com/nan/-/nan-2.11.1.tgz#90e22bccb8ca57ea4cd37cc83d3819b52eea6766"[m
[36m@@ -4422,6 +4584,14 @@[m [mpath-type@^2.0.0:[m
   dependencies:[m
     pify "^2.0.0"[m
 [m
[32m+[m[32mpbf@^3.0.5:[m
[32m+[m[32m  version "3.1.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/pbf/-/pbf-3.1.0.tgz#f70004badcb281761eabb1e76c92f179f08189e9"[m
[32m+[m[32m  integrity sha512-/hYJmIsTmh7fMkHAWWXJ5b8IKLWdjdlAFb3IHkRBn1XUhIYBChVGfVwmHEAV3UfXTxsP/AKfYTXTS/dCPxJd5w==[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    ieee754 "^1.1.6"[m
[32m+[m[32m    resolve-protobuf-schema "^2.0.0"[m
[32m+[m
 pbkdf2@^3.0.3:[m
   version "3.0.17"[m
   resolved "https://registry.yarnpkg.com/pbkdf2/-/pbkdf2-3.0.17.tgz#976c206530617b14ebb32114239f7b09336e93a6"[m
[36m@@ -5082,6 +5252,11 @@[m [mpostcss@^7.0.2:[m
     source-map "^0.6.1"[m
     supports-color "^5.5.0"[m
 [m
[32m+[m[32mpotpack@^1.0.1:[m
[32m+[m[32m  version "1.0.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/potpack/-/potpack-1.0.1.tgz#d1b1afd89e4c8f7762865ec30bd112ab767e2ebf"[m
[32m+[m[32m  integrity sha512-15vItUAbViaYrmaB/Pbw7z6qX2xENbFSTA7Ii4tgbPtasxm5v6ryKhKtL91tpWovDJzTiZqdwzhcFBCwiMVdVw==[m
[32m+[m
 prepend-http@^1.0.0:[m
   version "1.0.4"[m
   resolved "https://registry.yarnpkg.com/prepend-http/-/prepend-http-1.0.4.tgz#d4f4562b0ce3696e41ac52d0e002e57a635dc6dc"[m
[36m@@ -5107,6 +5282,11 @@[m [mpromise-inflight@^1.0.1:[m
   resolved "https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz#98472870bf228132fcbdd868129bad12c3c029e3"[m
   integrity sha1-mEcocL8igTL8vdhoEputEsPAKeM=[m
 [m
[32m+[m[32mprotocol-buffers-schema@^3.3.1:[m
[32m+[m[32m  version "3.3.2"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/protocol-buffers-schema/-/protocol-buffers-schema-3.3.2.tgz#00434f608b4e8df54c59e070efeefc37fb4bb859"[m
[32m+[m[32m  integrity sha512-Xdayp8sB/mU+sUV4G7ws8xtYMGdQnxbeIfLjyO9TZZRJdztBGhlmbI5x1qcY4TG5hBkIKGnc28i7nXxaugu88w==[m
[32m+[m
 proxy-addr@~2.0.4:[m
   version "2.0.4"[m
   resolved "https://registry.yarnpkg.com/proxy-addr/-/proxy-addr-2.0.4.tgz#ecfc733bf22ff8c6f407fa275327b9ab67e48b93"[m
[36m@@ -5215,6 +5395,11 @@[m [mquerystringify@^2.0.0:[m
   resolved "https://registry.yarnpkg.com/querystringify/-/querystringify-2.1.0.tgz#7ded8dfbf7879dcc60d0a644ac6754b283ad17ef"[m
   integrity sha512-sluvZZ1YiTLD5jsqZcDmFyV2EwToyXZBfpoVOmktMmW+VEnhgakFHnasVph65fOjGPTWN0Nw3+XQaSeMayr0kg==[m
 [m
[32m+[m[32mquickselect@^1.0.0:[m
[32m+[m[32m  version "1.1.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/quickselect/-/quickselect-1.1.1.tgz#852e412ce418f237ad5b660d70cffac647ae94c2"[m
[32m+[m[32m  integrity sha512-qN0Gqdw4c4KGPsBOQafj6yj/PA6c/L63f6CaZ/DCF/xF4Esu3jVmKLUDYxghFx8Kb/O7y9tI7x2RjTSXwdK1iQ==[m
[32m+[m
 randombytes@^2.0.0, randombytes@^2.0.1, randombytes@^2.0.5:[m
   version "2.0.6"[m
   resolved "https://registry.yarnpkg.com/randombytes/-/randombytes-2.0.6.tgz#d302c522948588848a8d300c932b44c24231da80"[m
[36m@@ -5318,6 +5503,16 @@[m [mreadable-stream@^3.0.6:[m
     string_decoder "^1.1.1"[m
     util-deprecate "^1.0.1"[m
 [m
[32m+[m[32mreadable-stream@~1.1.0:[m
[32m+[m[32m  version "1.1.14"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.1.14.tgz#7cf4c54ef648e3813084c636dd2079e166c081d9"[m
[32m+[m[32m  integrity sha1-fPTFTvZI44EwhMY23SB54WbAgdk=[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    core-util-is "~1.0.0"[m
[32m+[m[32m    inherits "~2.0.1"[m
[32m+[m[32m    isarray "0.0.1"[m
[32m+[m[32m    string_decoder "~0.10.x"[m
[32m+[m
 readdirp@^2.0.0:[m
   version "2.2.1"[m
   resolved "https://registry.yarnpkg.com/readdirp/-/readdirp-2.2.1.tgz#0e87622a3325aa33e892285caf8b4e846529a525"[m
[36m@@ -5335,6 +5530,13 @@[m [mredent@^1.0.0:[m
     indent-string "^2.1.0"[m
     strip-indent "^1.0.1"[m
 [m
[32m+[m[32mredeyed@~0.4.0:[m
[32m+[m[32m  version "0.4.4"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/redeyed/-/redeyed-0.4.4.tgz#37e990a6f2b21b2a11c2e6a48fd4135698cba97f"[m
[32m+[m[32m  integrity sha1-N+mQpvKyGyoRwuakj9QTVpjLqX8=[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    esprima "~1.0.4"[m
[32m+[m
 reduce-css-calc@^1.2.6, reduce-css-calc@^1.2.7:[m
   version "1.3.0"[m
   resolved "https://registry.yarnpkg.com/reduce-css-calc/-/reduce-css-calc-1.3.0.tgz#747c914e049614a4c9cfbba629871ad1d2927716"[m
[36m@@ -5501,6 +5703,13 @@[m [mresolve-from@^3.0.0:[m
   resolved "https://registry.yarnpkg.com/resolve-from/-/resolve-from-3.0.0.tgz#b22c7af7d9d6881bc8b6e653335eebcb0a188748"[m
   integrity sha1-six699nWiBvItuZTM17rywoYh0g=[m
 [m
[32m+[m[32mresolve-protobuf-schema@^2.0.0:[m
[32m+[m[32m  version "2.1.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/resolve-protobuf-schema/-/resolve-protobuf-schema-2.1.0.tgz#9ca9a9e69cf192bbdaf1006ec1973948aa4a3758"[m
[32m+[m[32m  integrity sha512-kI5ffTiZWmJaS/huM8wZfEMer1eRd7oJQhDuxeCLe3t7N7mX3z94CN0xPxBQxFYQTSNz9T0i+v6inKqSdK8xrQ==[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    protocol-buffers-schema "^3.3.1"[m
[32m+[m
 resolve-url@^0.2.1:[m
   version "0.2.1"[m
   resolved "https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz#2c637fe77c893afd2a663fe21aa9080068e2052a"[m
[36m@@ -5557,6 +5766,11 @@[m [mrun-queue@^1.0.0, run-queue@^1.0.3:[m
   dependencies:[m
     aproba "^1.1.1"[m
 [m
[32m+[m[32mrw@^1.3.3:[m
[32m+[m[32m  version "1.3.3"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/rw/-/rw-1.3.3.tgz#3f862dfa91ab766b14885ef4d01124bfda074fb4"[m
[32m+[m[32m  integrity sha1-P4Yt+pGrdmsUiF700BEkv9oHT7Q=[m
[32m+[m
 safe-buffer@5.1.2, safe-buffer@^5.0.1, safe-buffer@^5.1.0, safe-buffer@^5.1.1, safe-buffer@^5.1.2, safe-buffer@~5.1.0, safe-buffer@~5.1.1:[m
   version "5.1.2"[m
   resolved "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz#991ec69d296e0313747d59bdfd2b745c35f8828d"[m
[36m@@ -5753,6 +5967,18 @@[m [mshallow-clone@^1.0.0:[m
     kind-of "^5.0.0"[m
     mixin-object "^2.0.1"[m
 [m
[32m+[m[32msharkdown@^0.1.0:[m
[32m+[m[32m  version "0.1.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/sharkdown/-/sharkdown-0.1.0.tgz#61d4fe529e75d02442127cc9234362265099214f"[m
[32m+[m[32m  integrity sha1-YdT+Up510CRCEnzJI0NiJlCZIU8=[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    cardinal "~0.4.2"[m
[32m+[m[32m    expect.js "~0.2.0"[m
[32m+[m[32m    minimist "0.0.5"[m
[32m+[m[32m    split "~0.2.10"[m
[32m+[m[32m    stream-spigot "~2.1.2"[m
[32m+[m[32m    through "~2.3.4"[m
[32m+[m
 shebang-command@^1.2.0:[m
   version "1.2.0"[m
   resolved "https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz#44aac65b695b03398968c39f363fee5deafdf1ea"[m
[36m@@ -5940,6 +6166,13 @@[m [msplit-string@^3.0.1, split-string@^3.0.2:[m
   dependencies:[m
     extend-shallow "^3.0.0"[m
 [m
[32m+[m[32msplit@~0.2.10:[m
[32m+[m[32m  version "0.2.10"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/split/-/split-0.2.10.tgz#67097c601d697ce1368f418f06cd201cf0521a57"[m
[32m+[m[32m  integrity sha1-Zwl8YB1pfOE2j0GPBs0gHPBSGlc=[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    through "2"[m
[32m+[m
 sprintf-js@~1.0.2:[m
   version "1.0.3"[m
   resolved "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz#04e6926f662895354f3dd015203633b857297e2c"[m
[36m@@ -6024,6 +6257,13 @@[m [mstream-shift@^1.0.0:[m
   resolved "https://registry.yarnpkg.com/stream-shift/-/stream-shift-1.0.0.tgz#d5c752825e5367e786f78e18e445ea223a155952"[m
   integrity sha1-1cdSgl5TZ+eG944Y5EXqIjoVWVI=[m
 [m
[32m+[m[32mstream-spigot@~2.1.2:[m
[32m+[m[32m  version "2.1.2"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/stream-spigot/-/stream-spigot-2.1.2.tgz#7de145e819f8dd0db45090d13dcf73a8ed3cc035"[m
[32m+[m[32m  integrity sha1-feFF6Bn43Q20UJDRPc9zqO08wDU=[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    readable-stream "~1.1.0"[m
[32m+[m
 strict-uri-encode@^1.0.0:[m
   version "1.1.0"[m
   resolved "https://registry.yarnpkg.com/strict-uri-encode/-/strict-uri-encode-1.1.0.tgz#279b225df1d582b1f54e65addd4352e18faa0713"[m
[36m@@ -6060,6 +6300,11 @@[m [mstring_decoder@^1.1.1:[m
   dependencies:[m
     safe-buffer "~5.1.0"[m
 [m
[32m+[m[32mstring_decoder@~0.10.x:[m
[32m+[m[32m  version "0.10.31"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz#62e203bc41766c6c28c9fc84301dab1c5310fa94"[m
[32m+[m[32m  integrity sha1-YuIDvEF2bGwoyfyEMB2rHFMQ+pQ=[m
[32m+[m
 strip-ansi@^3.0.0, strip-ansi@^3.0.1:[m
   version "3.0.1"[m
   resolved "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz#6a385fb8853d952d5ff05d0e8aaf94278dc63dcf"[m
[36m@@ -6111,6 +6356,13 @@[m [mstyle-loader@^0.21.0:[m
     loader-utils "^1.1.0"[m
     schema-utils "^0.4.5"[m
 [m
[32m+[m[32msupercluster@^5.0.0:[m
[32m+[m[32m  version "5.0.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/supercluster/-/supercluster-5.0.0.tgz#2a5a9b1ffbd0d6180dea10039d78b5d95fdb8f27"[m
[32m+[m[32m  integrity sha512-9eeD5Q3908+tqdz+wYHHzi5mLKgnqtpO5mrjUfqr67UmGuOwBtVoQ9pJJrfcVHwMwC0wEBvfNRF9PgFOZgsOpw==[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    kdbush "^3.0.0"[m
[32m+[m
 supports-color@^2.0.0:[m
   version "2.0.0"[m
   resolved "https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz#535d045ce6b6363fa40117084629995e9df324c7"[m
[36m@@ -6185,6 +6437,11 @@[m [mthrough2@^2.0.0:[m
     readable-stream "~2.3.6"[m
     xtend "~4.0.1"[m
 [m
[32m+[m[32mthrough@2, through@~2.3.4:[m
[32m+[m[32m  version "2.3.8"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/through/-/through-2.3.8.tgz#0dd4c9ffaabc357960b1b724115d7e0e86a2e1f5"[m
[32m+[m[32m  integrity sha1-DdTJ/6q8NXlgsbckEV1+Doai4fU=[m
[32m+[m
 thunky@^1.0.2:[m
   version "1.0.3"[m
   resolved "https://registry.yarnpkg.com/thunky/-/thunky-1.0.3.tgz#f5df732453407b09191dae73e2a8cc73f381a826"[m
[36m@@ -6197,6 +6454,11 @@[m [mtimers-browserify@^2.0.4:[m
   dependencies:[m
     setimmediate "^1.0.4"[m
 [m
[32m+[m[32mtinyqueue@^1.1.0:[m
[32m+[m[32m  version "1.2.3"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/tinyqueue/-/tinyqueue-1.2.3.tgz#b6a61de23060584da29f82362e45df1ec7353f3d"[m
[32m+[m[32m  integrity sha512-Qz9RgWuO9l8lT+Y9xvbzhPT2efIUIFd69N7eF7tJ9lnQl0iLj1M7peK7IoUGZL9DJHw9XftqLreccfxcQgYLxA==[m
[32m+[m
 to-arraybuffer@^1.0.0:[m
   version "1.0.1"[m
   resolved "https://registry.yarnpkg.com/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz#7d229b1fcc637e466ca081180836a7aabff83f43"[m
[36m@@ -6499,6 +6761,15 @@[m [mvm-browserify@0.0.4:[m
   dependencies:[m
     indexof "0.0.1"[m
 [m
[32m+[m[32mvt-pbf@^3.0.1:[m
[32m+[m[32m  version "3.1.1"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/vt-pbf/-/vt-pbf-3.1.1.tgz#b0f627e39a10ce91d943b898ed2363d21899fb82"[m
[32m+[m[32m  integrity sha512-pHjWdrIoxurpmTcbfBWXaPwSmtPAHS105253P1qyEfSTV2HJddqjM+kIHquaT/L6lVJIk9ltTGc0IxR/G47hYA==[m
[32m+[m[32m  dependencies:[m
[32m+[m[32m    "@mapbox/point-geometry" "0.1.0"[m
[32m+[m[32m    "@mapbox/vector-tile" "^1.3.1"[m
[32m+[m[32m    pbf "^3.0.5"[m
[32m+[m
 watchpack@^1.4.0:[m
   version "1.6.0"[m
   resolved "https://registry.yarnpkg.com/watchpack/-/watchpack-1.6.0.tgz#4bc12c2ebe8aa277a71f1d3f14d685c7b446cd00"[m
[36m@@ -6626,6 +6897,11 @@[m [mwebsocket-extensions@>=0.1.1:[m
   resolved "https://registry.yarnpkg.com/websocket-extensions/-/websocket-extensions-0.1.3.tgz#5d2ff22977003ec687a4b87073dfbbac146ccf29"[m
   integrity sha512-nqHUnMXmBzT0w570r2JpJxfiSD1IzoI+HGVdd3aZ0yNi3ngvQ4jv1dtHt5VGxfI2yj5yqImPhOK4vmIh2xMbGg==[m
 [m
[32m+[m[32mwgs84@0.0.0:[m
[32m+[m[32m  version "0.0.0"[m
[32m+[m[32m  resolved "https://registry.yarnpkg.com/wgs84/-/wgs84-0.0.0.tgz#34fdc555917b6e57cf2a282ed043710c049cdc76"[m
[32m+[m[32m  integrity sha1-NP3FVZF7blfPKigu0ENxDASc3HY=[m
[32m+[m
 whet.extend@~0.9.9:[m
   version "0.9.9"[m
   resolved "https://registry.yarnpkg.com/whet.extend/-/whet.extend-0.9.9.tgz#f877d5bf648c97e5aa542fadc16d6a259b9c11a1"[m
