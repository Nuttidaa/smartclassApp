# Product Requirement Document (PRD)

## Project Name

Smart Class Check-in & Learning Reflection App

---

## 1. Problem Statement

In many university classes, instructors cannot easily verify whether students are physically present in the classroom or actively participating in the learning process. Traditional attendance systems such as signing a sheet or manually checking attendance are inefficient and prone to errors.

This application aims to provide a simple mobile solution that allows students to check in to class using GPS location and QR code scanning. It also encourages students to reflect on their learning experience before and after the class session.

---

## 2. Target Users

Primary users:

* University students attending a class session.

Secondary users:

* Instructors who want to verify student attendance and engagement.

---

## 3. Key Features

### 1. Class Check-in (Before Class)

Students perform the following steps before class begins:

* Press **Check-in**
* The system records:

  * GPS Location
  * Timestamp
* Students scan the classroom **QR Code**
* Students fill in the following information:

  * Topic covered in the previous class
  * Topic expected to learn today
  * Mood before class (1–5 scale)

Mood scale:

| Score | Mood             |
| ----- | ---------------- |
| 1     | 😡 Very negative |
| 2     | 🙁 Negative      |
| 3     | 😐 Neutral       |
| 4     | 🙂 Positive      |
| 5     | 😄 Very positive |

---

### 2. Class Completion (After Class)

At the end of the class, students complete the following:

* Press **Finish Class**
* Scan the class **QR Code**
* System records:

  * GPS Location
  * Timestamp

Students also submit:

* What they learned today (short text)
* Feedback about the class or instructor

---

## 4. User Flow

1. User opens the application.
2. The **Home Screen** displays two options:

   * Check-in
   * Finish Class
3. If the user selects **Check-in**:

   * Scan QR code
   * Record GPS location
   * Fill in check-in form
   * Submit check-in
4. If the user selects **Finish Class**:

   * Scan QR code
   * Record GPS location
   * Fill in learning reflection form
   * Submit completion form

---

## 5. Data Fields

### Check-in Data

* previousTopic (String)
* expectedTopic (String)
* mood (Integer)
* latitude (Double)
* longitude (Double)
* timestamp (DateTime)
* qrCodeData (String)

### Finish Class Data

* learnedToday (String)
* feedback (String)
* latitude (Double)
* longitude (Double)
* timestamp (DateTime)
* qrCodeData (String)

---

## 6. Tech Stack

Frontend:

* Flutter

Device Features:

* GPS Location
* QR Code Scanner

Local Storage:

* Shared Preferences or SQLite

Deployment:

* Firebase Hosting (Flutter Web demo)

---

## 7. Minimum Viable Product (MVP)

The MVP version of the application includes:

* Home screen navigation
* Check-in form
* Finish class form
* GPS location capture
* QR code scanning
* Local data storage
* Simple deployment using Firebase Hosting
