# Foursquare App

App uses Foursquare API to display information about nearby places
around user using user’s current location specified by Latitude and
Longitude

## Installation

Use Cocoapods.

```bash
git clone https://github.com/MohammedBadr20s/Foursquare.git

pod install

build and run
```

## Usage

```python
1- Open app and it will ask you for location permission
2- you have to allow for the use of Location Services
3- App will load the current nearby places to your current location the first time only
4- If you want to get real time updates of your nearby places every 500 Meter Press on
 Real Time Button at the top right of the screen
```
## Summary
```python
This App is Demo for:
1- MVVM-C (Model View ViewModel Coordinator) Architecture Pattern
2- Router
3- Protocol Oriented Network Layer
4- CoreLocation Manager
5- Asking for permissions even if it's denied
6- Dark & Light Modes Supported
7- Unit Testing
8- Project Schemes & Configurations
```

## Project Schemes & Configurations
```python
1- Foursquare is the LOCAL Environment which is responsible for Local Testing
2- Dev Foursquare is The Dev Environment which is responsible for Development Testing
3- Production Foursquare is The Production Environment which is published to End-Users
```
### Note: Foursquare Api has a Quota limit of Number of getPhoto Requests within specific time for each place so if it exceeds limit we will have to wait some time to get new photos
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
