# OGC Inventory Management App

A **Flutter-based inventory and production management application** developed for **OGCreation** to track materials, monitor production, and manage product dispatch operations efficiently.

This application helps streamline internal workflows by recording the movement of materials through different stages of the company’s operations — **Inward, Production, and Outward** — while providing a clear dashboard overview and search functionality.

---

## 📱 Features

### 1. Dashboard
<p align="center">
  <img src="https://github.com/user-attachments/assets/1e7a0a49-ec62-42a4-9701-39bb68370d54" width="250"/>
</p>

Provides a quick overview of operational activity within the system.

- Displays summary of entries  
- Quick insight into inventory flow  
- Easy navigation to different modules  

---

### 2. Inward Management
<p align="center">
  <img src="https://github.com/user-attachments/assets/6c0e3bb1-899a-4773-93b7-670627748357" width="250"/>
</p>

Used to record materials entering the inventory.

- Add new inward entries  
- Track supplier deliveries  
- Maintain records of incoming stock  

**Example data recorded:**
- Material name  
- Quantity  
- Supplier  
- Date  

---

### 3. Production Tracking
<p align="center">
  <img src="https://github.com/user-attachments/assets/e8fef1ee-b72e-4bb8-bad6-59fcae75cb15" width="250"/>
</p>

Tracks how raw materials are used in the production process.

- Record material consumption  
- Monitor production activities  
- Maintain manufacturing logs  

**Example data recorded:**
- Raw material used  
- Quantity used  
- Production date  

---

### 4. Outward Management
<p align="center">
  <img src="https://github.com/user-attachments/assets/d820ae90-4fbc-4336-b800-1f8aec5cc643" width="250"/>
</p>

Tracks finished goods leaving the company.

- Record shipments or dispatch  
- Track outgoing products  
- Maintain delivery logs  

**Example data recorded:**
- Product name  
- Quantity shipped  
- Destination  
- Date  

---

### 5. Search System
<p align="center">
  <img src="https://github.com/user-attachments/assets/5d3b8782-d5d8-4050-86ab-af41c9cb9f1d" width="250"/>
</p>

Allows users to quickly locate inventory records.

- Search across inward entries  
- Search production logs  
- Search outward dispatch records  

---

## 🏗️ Project Structure

```
lib/
 ├── models/        # Data models for inventory entries
 ├── screens/       # UI screens and application pages
 ├── services/      # Data storage and app services
 ├── theme/         # App styling and theme configuration
 └── main.dart      # Application entry point
```

### Models

Defines structured data objects used throughout the app.

Examples:

* InwardEntry
* ProductionEntry
* OutwardEntry

### Screens

Contains UI components and major application modules.

Main tabs include:

* Dashboard
* Inward
* Production
* Outward
* Search

### Services

Handles local data storage and data operations.

### Theme

Contains styling configuration used across the application.

---

## ⚙️ Tech Stack

* **Flutter**
* **Dart**
* Local Storage (for persistent data)
* Material UI Components

---

## 🏢 Use Case

This application is designed for **small to medium manufacturing or inventory-based businesses** to manage their internal material workflow.

Typical workflow:

```
Raw Materials Received
        ↓
Recorded in Inward
        ↓
Used in Production
        ↓
Finished Goods Created
        ↓
Dispatched via Outward
```

---

## 🚀 Getting Started

### 1. Clone the repository

```
git clone https://github.com/BHANJATANMAYA/OGC_APP.git
```

### 2. Navigate to the project

```
cd ogc_inventory_app
```

### 3. Install dependencies

```
flutter pub get
```

### 4. Run the application

```
flutter run
```

---

## 📌 Future Improvements

Potential features that can enhance the application:

* Cloud synchronization
* Multi-user access
* Authentication system
* Export reports (PDF / Excel)
* Real-time analytics dashboard
* Barcode scanning for inventory

---

## 👨‍💻 Author

**Tanmaya Bhanja**

Developed as an internal inventory solution for **OGCreation**.

---

## 📄 License

This project is intended for internal or demonstration use.

