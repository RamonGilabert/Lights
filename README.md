<div align = "center">
<img src="https://github.com/RamonGilabert/Lights/blob/master/Resources/lights.jpg" />
<br>
</div>

**Lights** is a project that was born last November with the motivation to get my electronic knowledge together with my development one, they met and this is the first product out of it, the first product of a connected home, a light.

**Lights** is basically a combination of different projects, being this the iOS app the central part of it.

There is also a Raspberry Pi and an Arduino involved into the equation, being controlled by a server running in the cloud.

- [Lights Backend](https://github.com/RamonGilabert/Lights-Backend)
- [Lights Berry](https://github.com/RamonGilabert/Lights-Berry)
- [Lights Duino](https://github.com/RamonGilabert/Lights-Duino)

The first two written in NodeJS and the last one in Arduino.

All together makes it easy to just connect a hub into your home (Raspberry Pi). This one will connect into the central server right away and then start to look for small lights (Arduino), once this one is found, it will connect to it and basically start waiting for commands.

**Lights** can control:

- Intensity.
- RGB values.
- State.

The lamp of it still has no design, so it will take some time before it's fully done.
