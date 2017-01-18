# IoTBroker.Cloud iOS Client

IoTBroker.Cloud is iOS client which allows to connect to MQTT server via iPhone. IoTBroker.Cloud iOS client sticks to [MQTT 3.1.1](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.pdf) standards. 

## Features

* **Clean / persistent session.** When the client disconnects, its session state can be stored (if you set Clean session flag to false) or removed (if you set Clean session flag to true). The session state includes subscriptions and incoming QoS 1 and QoS 2 messages while the client is off.

* **Last Will and Testament.** This feature implies that if a client goes offline without sending DISCONNECT message (due to some failure), other clients will be notified about that.

* **Keep Alive.** If Keep Alive is higher than 0, the client and the server is constantly exchanging PING messages to make sure whether the opposite side is still available. 

* **Retain messages.** It allows to "attach" a message to a particular topic, so the new subscribers become immediately aware of the last known state of a topic.

* **Assured message delivery.** Each message is sent according to the level of Quality of Service (QoS). QoS has 3 levels:
- QoS 0 (At most once) — a message is sent only one time. The fastest message flow, but message loss may take place. 
- QoS 1 (At least once) — a message is sent at least one time. The message duplication may occur.  
- QoS 2 (Exactly once) — a message is sent exactly one time.  But QoS 2 message flow is the slowest one. 

## Getting Started

These instructions will help you get a copy of the project and run it.

### Prerequisites

**Xcode** should be installed before starting to clone IoTBroker.Cloud iOS Client. Pay attention that supported version of iOS is 10.0 or higher. 

### Installation

* To install IoTBroker.Cloud on your iPhone, first you should download [IotBroker.Cloud iOS Client](https://github.com/mobius-software-ltd/iotbroker.cloud-ios-client).

* In order to open IoTBroker.Cloud iOS client in Xcode, you should go to *File-Open-Choose project*. It is necessary to choose **iotbroker.cloud-client.xcodeproj** file.

* Now you should connect your iPhone to Mac via USB.

* On the **Scheme** toolbar menu you should choose your device and click **Play** icon.

In a few minutes IotBroker iOS Client will be available for use as any other mobile application. When you finished with installation, you can open IoTBroker.Cloud on your iPhone and log in.

Now you are able to start exchanging messages with MQTT server.

Please note that at this stage it is not possible to register as a client. You can log in to your existing account.

## [License](LICENSE.md)



