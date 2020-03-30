# Super Cool Name of Our Project

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
  * [A Real-Time View of Store Capacity](#a-real-time-view-of-store-capacity)
  * [A Store Management System](#a-store-management-system)
  * [A Reservation System for Fast Store Access](#a-reservation-system-for-fast-store-access)
* [Technical Details](#technical-details)
  * [Prerequisites](#prerequisites)
  * [Running the App](#running-the-app)
* [Screenshots](#screenshots)
* [Authors](#authors)

## About The Project
Switzerland is on lockdown. Restaurants, bars, museums, etc. have been closed and all social events have been cancelled. The Swiss Federal Council has imposed strict social distancing rules on the Swiss people and has advised them to stay at home, if possible. Recent data seems to suggest that the people are following this advice.

However, for grocery shopping or getting medical prescriptions from the drug store, people still have to leave their homes. As there are strict regulations on how many people are allowed to be in a room, we often encounter long queues in front of stores like Migros or Coop. In the latter case, people are given a numbered card upon entry that they have to return when leaving the store. This solution is unhygienic and inefficient.

### A Real-Time View of Store Capacity
NAME_PLACEHOLDER is an app that runs on both iOS and Android smartphones and displays real-time data on stores arround your current or a custom location:
- The maximum number of people allowed in the store.
- The current number of people that are in the store.
- Historic data that show when stores are the most- and least crowded.

From the user's perspective, NAME_PLACEHOLDER allows him or her to shop more efficiently and avoid people by choosing to shop in the least crowded store. From a higher perspective, NAME_PLACEHOLDER helps to reduce the risk of transmission of Covid-19 by providing load-balancing across stores for an essential activity where people have to leave their homes.

### A Store Management System
The NAME_PLACEHOLDER app offers both a customer and a store side. The security personnel at the store entrance can use the app to increase and decrease the people count when people enter and leave the store, respectively, which updates the database in real-time. The app can be operated by multiple security personnel at once in case there are multiple entrances and exits.

This increases efficiency as the database takes care of synchronization accross multiple users and also increases hygiene because it eliminates the need for entry cards that potentially hundreds of people touch over the course of a single day.

### A Reservation System for Fast Store Access
NAME_PLACEHOLDER additionally offers a reservation system for entry slots. Each store dedicates a percentage of its available entry slots to online reservation. Users can then book a such slot for a store at a designated date and time and be granted direct access by skipping the line. The process is as follows:

1. The user selects a store, a date and a desired entry time on the app.
2. The user makes a confirmation request by pressing the "Book" button.
3. If the reservation is granted, the user receives a QR-code that is stored locally in the app.
4. The user can skip the queue at the store and the security personnel scans the QR code with the app, allowing entry if the check was successful. (INFO: We allow for a +/- 10 minute tolerance with respect to the entry time)

The reservation system allows a user to plan his or her shopping more comfortably as he is guaranteed immediate entry, thus further reducing his or her time away from home.

## Technical Details
### Prerequisites

### Running the App

## Screenshots


## Authors
We are four students that have recently graduated with a BSc. in Computer Science from ETH Zurich and will start our master's degree this fall.
* [Jens Eirik Saethre (@saethrej)](https://linkedin.com/in/saethrej)
* [André Gaillard (@andregail)]()
* [Livio Schläpfer (@livioschlaepfer)](https://www.linkedin.com/in/livio-schl%C3%A4pfer-b34607179/)
* [Christopher Raffl (@rafflc)](https://www.linkedin.com/in/christopher-raffl-94a2a4180/)

