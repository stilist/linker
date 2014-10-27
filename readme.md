## Usage

1. `bundle install --path vendor/gems`
1. `./bin/cli create demo --title "Testing!" --description "My favorite link" --s3_bucket "www.example.org" --s3_id SAMPLE --s3_key SAMPLE`
1. `./bin/cli add demo --url http://example.org --description "Sample link"`
1. `./bin/cli build demo`
1. `./bin/cli publish demo`
1. `open public/demo/index.html`

[Live example](http://www.yougottaclickthis.link/)
