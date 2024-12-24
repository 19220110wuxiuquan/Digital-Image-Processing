import tensorflow as tf
from tensorflow.keras import layers, models
from tensorflow.keras.applications.resnet50 import ResNet50
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import matplotlib
matplotlib.use('TkAgg')
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
    image = image / 255.0
    return image, label

AUTOTUNE = tf.data.experimental.AUTOTUNE
BATCH_SIZE = 16 # 增大批次大小
# 加载和预处理图像
train_ds = train_ds.map(load_img, num_parallel_calls=AUTOTUNE).cache()  # 添加缓存
test_ds = test_ds.map(load_img, num_parallel_calls=AUTOTUNE).cache()

# 配置数据集以提高性能
train_ds = train_ds.repeat().shuffle(300).batch(BATCH_SIZE).prefetch(buffer_size=AUTOTUNE)
test_ds = test_ds.batch(BATCH_SIZE).prefetch(buffer_size=AUTOTUNE)

# 加载预训练的ResNet50模型，不包括顶层的全连接层
base_model = ResNet50(include_top=False, weights='imagenet', input_shape=(256, 256, 3))

# 冻结基础模型的层，不让它们在训练过程中更新
base_model.trainable = False

# 构建新的模型，在ResNet50的基础上添加自定义的顶层
model = models.Sequential([
    base_model,
    layers.GlobalAveragePooling2D(),
    layers.Dense(512, activation='relu'),  # 精简了全连接层神经元数量
    layers.BatchNormalization(),
    layers.Dense(200, activation='softmax')  # 假设有200个类别
])

# 编译模型，调整了学习率
model.compile(optimizer=tf.keras.optimizers.Adam(0.001),
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# 打印模型结构
model.summary()

# 训练模型
train_steps_per_epoch = len(train_path) // BATCH_SIZE
test_steps_per_epoch = len(test_path) // BATCH_SIZE

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

# 保存模型（修改后的保存方式）
filepath = r'C:\Users\22756\Desktop\Digital-Image-Processing\model_birds_resnet.h5'
model.save(filepath)

print("模型训练完成并已保存")