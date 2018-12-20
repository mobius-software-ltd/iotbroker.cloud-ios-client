# IoTBroker.Cloud iOS Client

### Project description

IoTBroker.cloud IOS Client is an application that allows you to connect to the server using MQTT, MQTT-SN, 
AMQP or COAP protocols. IoTBroker.cloud IOS Client gives the opportunity to exchange messages using protocols 
mentioned above. Your data can be also encrypted with **TLS** or **DTLS** secure protocols.   

Below you can find a brief description of each protocol that can help you make your choice. 
If you need to get more information, you can find it in our [blog](https://www.iotbroker.cloud/clientApps/Android/MQTT).
 
**MQTT** is a lightweight publish-subscribe based messaging protocol built for use over TCP/IP.  
MQTT was designed to provide devices with limited resources an easy way to communicate effectively. 
You need to familiarize yourself with the following MQTT features such as frequent communication drops, low bandwidth, 
low storage and processing capabilities of devices. 

Frankly, **MQTT-SN** is very similar to MQTT, but it was created for avoiding the potential problems that may occur at WSNs. 

Creating large and complex systems is always associated with solving data exchange problems between their various nodes. 
Additional difficulties are brought by such factors as the requirements for fault tolerance, 
he geographical diversity of subsystems, the presence a lot of nodes interacting with each others. 
The **AMQP** protocol was developed to solve all these problems, which has three basic concepts: 
exchange, queue and routing key. 

If you need to find a simple solution, it is recommended to choose the **COAP** protocol. 
The CoAP is a specialized web transfer protocol for use with constrained nodes and constrained (e.g., low-power, lossy) 
networks. It was developed to be used in very simple electronics devices that allows them to communicate interactively 
over the Internet. It is particularly targeted for small low power sensors, switches, valves and similar components 
that need to be controlled or supervised remotely, through standard Internet networks.   
 
### Prerequisites 

**Xcode** should be installed before starting to clone IoTBroker.Cloud iOS Client. Pay attention that supported version of iOS is 10.0 or higher. 

### Installation

If you do not have Xcode installed on your Mac, you should do the following:

* First it is necessary to go to [Apple Developer website](https://developer.apple.com/) and to sign in to your account or register the new one if you yet do not have the account. In order to register you should go to Account section and press the **Create Apple ID** button.

* In your account you should go to **Downloads** tab and download **Xcode**. You will be forwarded to the corresponding page. Here you should press **View** in Mac App Store button. On the Xcode pop-up window you should press **Get** button to start the download process. On your Mac you will find the downloaded Xcode in DMG extension. To start working with Xcode you should open this DMG file and run Xcode.

* To install IoTBroker.Cloud on your iPhone, first you should download IoTBroker.Cloud iOS client

* In order to open IoTBroker.Cloud iOS client in Xcode, first you should **go to File-Open-Choose project**. It is necessary to choose **iotbroker.cloud-client.xcodeproj file**.

* Now you should connect your iPhone to Mac via USB or via Wi-Fi.

* On the Scheme toolbar menu you should choose your device and click Play icon.

In a few minutes IotBroker iOS Client will be available for use as any other mobile application. When you finished with installation, you can open IoTBroker.Cloud on your iPhone and log in.

Now you are able to start exchanging messages with server.

Please note that at this stage it is not possible to register as a client. You can log in to your existing account.

IoTBroker.Cloud iOS Client is developed by [Mobius Software](http://mobius-software.com).

## [License](LICENSE.md)



