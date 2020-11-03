# Leaffix 
## Introduction
Leaffix is a program to detect 3 types of apple leaf disease: rust, scab and multiple diseases as well as healthy leaf using Yolo V2 in MATLAB.</br>
The image dataset of this project is based on the Plant Pathology 2020 - FGVC7 competition available in https://www.kaggle.com/c/plant-pathology-2020-fgvc7/data.
## Training
To start training and testing the files: imageLabelingSession_150.mat and imageTestingSession_30.mat is already prepared. These file are the object labeled of the leaves in 600 images for training (150 images each class) and  120 images for testing (30 images each class).</br>
It is a room for improvement by continue adding more object labeled image on training, you can continue to do that by download the train labeled folder and open the imageLabelingSession_150.mat with Image Labeler app in MATLAB.
The performance of the trained detector is as follows:</br>
![trained detector performance](https://github.com/neumotngayem/Leaffix/blob/main/performance.png?raw=true)</br>
It shows that all the recall score is very low but overall precision can reach around 0.8 except the multiple disease class only able to reach 0.6. It can be described that the program does not well recognize the object but when it can recognize, it can classify the object correctly.
## UI
After training, the model is packed and using in the GUI of the program, the code of it is in the UI folder.
</br>
![Leaffix Main UI](https://github.com/neumotngayem/Leaffix/blob/main/mainui.png?raw=true)
</br>
![Leaffix Detection UI](https://github.com/neumotngayem/Leaffix/blob/main/multiple_diseases.jpg?raw=true)
</br>
Because most of the training data the leaf is horizontal, so it can detect the horizontal leaf better. In case the leaf is vertical, you can press the rotate to rotate the image to get a better prediction.
## Image Dataset
Training Dataset: https://drive.google.com/file/d/1DU9G-zijQ8UJcyVffVLKWpC6qKm0k8Aj/view?usp=sharing</br>
Testing Dataset: https://drive.google.com/file/d/1NKTjaSmyagpsA_f3Y1avF0T7mzU5Qbnp/view?usp=sharing
