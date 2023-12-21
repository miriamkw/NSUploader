# NSUploader

This repository enables continuous uploading of health data from an iOS smartphone application to Nightscout, allowing real-time access through any programming language via the Nightscout web API. 

For Python integration, see [python-nightscout](https://github.com/miriamkw/python-nightscout), a modified API for easy health data access.



## Current status
- Connecting to HealthKit
- Uploading Heart Rates to Nightscout when app is in foreground
    - Some requirements for background deliveries are activated, but it is currently not working properly


## Future plans
- Upload data when app is running in background
- Add more datatypes:
    - Workouts
    - HRV
    - Respiratory rate
    - Steps
    - Etc...
- Use anchors properly, so that there are no duplicate values written to the api
- Handle all CRUD functionalities, so that Nightscout is properly in sync with apple health data
- Add a simple UI listing the most current activities


## Nighscout configuration

Note that sensitive credentials should be stored in a configuration file, `Config.swift`:

struct Config {
    static let url = "https://your_nightscout.database.com"
    static let apiSecret = "YOUR_API_KEY"
}


