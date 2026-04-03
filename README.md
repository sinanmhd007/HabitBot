# HabitBot – Habit Tracker with Automated Reminders

## Why I Built This Project
I built this project to learn how to integrate frontend applications with automation tools and understand real-world event-driven workflows. The goal was to go beyond basic app development and explore how user actions can trigger backend automation.

## Overview
HabitBot is a Flutter-based habit tracking application where users can create daily habits, track completion, and receive automated reminders at specific times.

## Features
- User authentication using Firebase  
- Create, update, and track daily habits  
- Streak tracking based on completion history  
- Automated reminders triggered at scheduled times  
- Integration with external messaging API for notifications  

## Tech Stack
- Flutter (Dart)  
- Firebase Authentication  
- Firebase Firestore  
- n8n (workflow automation)  
- Dio (API communication)  
- ngrok (local webhook testing)  

## Automation Workflow
The app sends a webhook to n8n when a habit is created.  
n8n processes the request, schedules a delay based on the habit time, and sends a notification using an external messaging API.

## How to Run
1. Clone the repository  
2. Set up Firebase configuration  
3. Run the Flutter app  
4. Import the n8n workflow JSON  
5. Update webhook URL and API credentials  
6. Start n8n and test the workflow  