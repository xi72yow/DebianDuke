# DebianDuke

## Roadmap

- [ ] Debian 12 Live ISO
- [ ] Hyprland installation
- [ ] Hyperland basic setup
  - [ ] Gnome like task bar
  - [ ] Clipboard Manager
  - [ ] Basic App Launcher
- [ ] Dracula Theming
- [ ] own debian ropo in cloud
  - [ ] ScreenChaser
  - [ ] Eddy
  - [ ] Popsicle
  - [ ] Dracula Github Desktop
- [ ] setup sourcelist for
  - [ ] Codeium
  - [ ] Chrome
  - [ ] LibreWolf
  - [ ] Discord
  - [ ] Steam
- [ ] System Applications
  - [ ] Dolphin/Nautilus
  - [ ] Kwrite/Gedit
  - [ ] Gwenview/EyeOfGnome
  - [ ] Konsole/GnomeTerminal/Hyper
  - [ ] Browser
  - [ ] Videoplayer
- [ ] Management AppImages
- [ ] Supported Hardware
  - [ ] Wacom Tablets
  - [ ] AMD CPU/GPU
- [ ] Documentation

## Setting Up Development Environment

To set up the development environment for DebianDuke, follow these steps:

1. Install Docker: Docker is required to build and run the Duke Builder container. You can download and install Docker from the official website: [https://www.docker.com/get-started](https://www.docker.com/get-started).

   We recommend using Docker Desktop, which provides an easy-to-use graphical interface for managing Docker containers. You can download Docker Desktop from the official website: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop).

2. Build the Duke Builder Container: Open a terminal and navigate to the directory where the `duke-builder.dockerfile` is located. Run the following command to build the Duke Builder container:

   ```shell
   docker build -t duke-builder -f duke-builder.dockerfile .
   ```

3. Run the Duke Builder Container: Once the container is built, run the following command to start the Duke Builder container:

   ```shell
   docker run -h duke-builder --privileged -p 2222:22 --restart=always -d duke-builder
   ```

4. Access the Duke Builder Container: To access the Duke Builder container via SSH, run the following command:

   ```shell
   ssh root@0.0.0.0 -p 2222
   ```

   Note: Use the Password `root123`

By following these steps, you will have set up the development environment for DebianDuke using Docker.
