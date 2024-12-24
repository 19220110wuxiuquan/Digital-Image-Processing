import tensorflow as tf
from tensorflow import keras
import matplotlib.pyplot as plt
import numpy as np
import glob
import os
from pathlib import Path

# 设置随机种子以保证结果可复现
np.random.seed(2024)

# 获取所有图片路径
imgs_path = glob.glob(r'D:\CUB_200_2011\images\*\*.jpg')

# 提取标签名称（使用更稳健的路径处理）
all_labels_name = [Path(imgs_p).parent.name for imgs_p in imgs_path]

# 获取唯一的标签名，并创建标签到索引的映射
label_names = np.unique(all_labels_name)
label_to_index = dict((name, i) for i, name in enumerate(label_names))
index_to_label = dict((v, k) for k, v in label_to_index.items())

# 将标签名称转换为索引
all_labels = [label_to_index.get(name) for name in all_labels_name]

# 打乱数据集
random_index = np.random.permutation(len(imgs_path))
imgs_path = np.array(imgs_path)[random_index]
all_labels = np.array(all_labels)[random_index]

# 划分训练集和测试集
train_count = int(len(imgs_path) * 0.8)
train_path = imgs_path[:train_count]
train_labels = all_labels[:train_count]
test_path = imgs_path[train_count:]
test_labels = all_labels[train_count:]

# 构建数据集
train_ds = tf.data.Dataset.from_tensor_slices((train_path, train_labels))
test_ds = tf.data.Dataset.from_tensor_slices((test_path, test_labels))

def load_img(path, label):
    image = tf.io.read_file(path)
    image = tf.image.decode_jpeg(image, channels=3)
    image = tf.image.resize(image, [256, 256])
    image = tf.cast(image, tf.float32)
    image = image / 255
    return image, label

AUTOTUNE = tf.data.experimental.AUTOTUNE
BATCH_SIZE = 4

# 加载和预处理图像
train_ds = train_ds.map(load_img, num_parallel_calls=AUTOTUNE)
test_ds = test_ds.map(load_img, num_parallel_calls=AUTOTUNE)

# 配置数据集以提高性能
train_ds = train_ds.repeat().shuffle(300).batch(BATCH_SIZE).prefetch(buffer_size=AUTOTUNE)
test_ds = test_ds.batch(BATCH_SIZE).prefetch(buffer_size=AUTOTUNE)

# 定义模型架构
model = tf.keras.Sequential([
    tf.keras.layers.Conv2D(32, (3, 3), input_shape=(256, 256, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Conv2D(32, (3, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.MaxPool2D(),
    tf.keras.layers.Conv2D(128, (3, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Conv2D(128, (3, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.MaxPool2D(),
    tf.keras.layers.Conv2D(256, (3, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Conv2D(256, (3, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.MaxPool2D(),
    tf.keras.layers.Conv2D(512, (3, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Conv2D(512, (3, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.MaxPool2D(),
    tf.keras.layers.Conv2D(512, (3, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Conv2D(512, (3, 3), activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.GlobalAvgPool2D(),
    tf.keras.layers.Dense(1024, activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Dense(200)  # 假设有200个类别
])

# 编译模型
model.compile(optimizer=tf.keras.optimizers.Adam(0.0001),
              loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])

# 训练模型
train_steps_per_epoch = len(train_path) // BATCH_SIZE
test_steps_per_epoch = len(test_path) // BATCH_SIZE
with tf.device('/GPU:0'):
    history = model.fit(
    train_ds,
    epochs=15,
    steps_per_epoch=train_steps_per_epoch,
    validation_data=test_ds,
    validation_steps=test_steps_per_epoch
)

# 绘制训练与验证的准确率和损失值
plt.figure(figsize=(12, 4))

plt.subplot(1, 2, 1)
plt.plot(history.epoch, history.history['accuracy'], label='Train Accuracy')
plt.plot(history.epoch, history.history['val_accuracy'], label='Validation Accuracy')
plt.title('Accuracy over Epochs')
plt.legend()

plt.subplot(1, 2, 2)
plt.plot(history.epoch, history.history['loss'], label='Train Loss')
plt.plot(history.epoch, history.history['val_loss'], label='Validation Loss')
plt.title('Loss over Epochs')
plt.legend()

plt.show()

# 保存模型
filepath = r'D:\model_birds'
model.save(filepath, save_format='h5')