
# WeatherApp

The assignment has the following <strong>requirements</strong>:
* Must be done in Ruby on Rails
* Accept an address as input
* Retrieve forecast data for the given address. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast)
* Display the requested forecast details to the user
* Cache the forecast details for 30 minutes for all subsequent requests by zip codes.
* Display indicator if result is pulled from cache.

#### Assumptions
* Imperial units (Fahrenheit, mph, etc)
* US-only addresses (requirements indicate caching on zip code as opposed to postal code)
* This project assumes you already have ruby install on your system. If not, please follow the instructions here:

<details>
	<summary>Install Ruby with asdf</summary>

* Install `asdf`
	```
	sudo apt-get update
	sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline-dev zlib1g-dev libncurses-dev libffi-dev libgdbm-dev
	sudo apt install curl git
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
	```
* call `code ~/.bashrc` to open your bash profile
* add `. $HOME/.asdf/asdf.sh` and `. $HOME/.asdf/completions/asdf.bash` to the end of the file
* add plugins and install ruby
	```
	asdf plugin add ruby
	asdf install ruby latest
	```
* find the version you installed with `asdf list ruby` and set the version globally
	```
	asdf list ruby
	asdf global ruby 3.2.2
	```

</details>

## Setup Instructions

1. Install homebrew
	```
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	```
2. Install and start redis
	```
	brew install redis
	brew services start redis
	```
3. Clone the repository
	```
	git clone https://github.com/krodante/weather_app.git
	```
	<strong>Note:</strong> I uploaded the `master.key` file to the repository in order for the assessment to be sent with only a single github link. I would not add this file in a true production environment, and instead would send it securely or use Vault secrets.

4. Navigate to the project directy and install gems
	```
	cd weather_app
	bundle install
	```
5. Run tests
	```
	rspec spec
	```
6. Run server at localhost:3000
	```
	rails s
	```

## Usage
Fetch current and forecast weather for a given address.
* In the browser, navigate to the root url [http://localhost:3000/](http://localhost:3000/)
* Enter any address
	* Address <strong>must</strong> contain a zip code. If there is no zip code, an error is returned.
* Current and Forecast weather is shown on the `weather/show` page.
	* It's a lot of information! Each column is one day, and each row of a column is a 3-hour segment.
	* For example, if you search at 11pm on May 11, 2023, one column will have up to eight forecasts for May 12, 2023, with the timestamps 0:00, 3:00, 6:00, 9:00, 12:00, 15:00, 18:00, and 21:00
* Click on the button or navigate back in the browser to return to the root url and search for another address.

## Questions
Please feel free to contact me at kathy.rodante@gmail.com if you have any questions. Thank you!
