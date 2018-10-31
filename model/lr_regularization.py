'''
线性回归——正则化
by Jim 2018.10.25
'''

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

from sklearn.linear_model import Ridge, Lasso, SGDRegressor


def cost_function(x, y, theta, reg_coef):
    m = x.shape[0]
    return (1 / (2 * m)) * (np.sum((x.dot(theta) - y) ** 2) + reg_coef * np.sum(theta[1:] ** 2) / 2)


def my_ridge(x, y, n_iters=1000, reg_coef=1.0, learning_rate=0.03):
    m = x.shape[0]
    # 添加全1列以便进行矩阵运算
    x_b = np.c_[np.ones((m, 1)), x]
    n = x_b.shape[1]
    # print(x_b)
    # print(y)
    theta = np.zeros((n, 1))  # n行1列
    # print(theta)
    # print(theta[1:])
    # print(np.r_[np.ones((1, 1)), reg_coef * theta[1:]])
    J = np.zeros((n_iters, 1))
    for i in range(n_iters):
        J[i] = cost_function(x_b, y, theta, reg_coef)
        grad = (1 / m) * (x_b.T.dot(x_b.dot(theta) - y) +
                          np.r_[np.zeros((1, 1)), reg_coef * theta[1:]])
        theta -= learning_rate * grad
    return theta, J


def stachastic_gd(x, y, n_epoches=100, reg_coef=1.0):
    m = len(y)
    x_b = np.c_[np.ones((m, 1)), x]
    n = x_b.shape[1]
    t0, t1 = 5, 50  # 学习率控制参数
    theta = np.zeros((n, 1))
    for epoch in range(n_epoches):
        for i in range(m):
            idx = np.random.randint(m)
            xi = x_b[idx: idx + 1]
            yi = y[idx: idx + 1]
            grad = xi.T.dot(xi.dot(theta) - yi) + np.r_[np.zeros((1, 1)), reg_coef * theta[1:]]
            theta -= grad * (t0 / (epoch * m + i + t1))  # 学习率
    return theta


if __name__ == "__main__":
    # 生成数据
    x = np.random.rand(100, 1)  # 均匀分布
    y = 4 + 3 * x + np.random.randn(100, 1)  # 标准正态

    # ---------------L2正则-------------- #
    # 批量梯度下降
    learning_rate = .1  # 学习率
    n_iters = 1000  # 迭代次数
    reg_coef = 1  # 正则化超参数
    theta, J_history = my_ridge(x, y, n_iters, reg_coef, learning_rate)
    print('batch_gd_L2:\n', theta)

    # plt.plot(J_history)
    # plt.xlabel('Iterations')
    # plt.ylabel('Cost')
    # plt.show()

    # plt.scatter(x, y)
    # plt.plot([min(x), max(x)], [theta[0] + theta[1] * min(x), theta[0] + theta[1] * max(x)], color='r')
    # plt.show()

    # 随机梯度下降
    n_epoches = 1000
    reg_coef = .01
    theta = stachastic_gd(x, y, n_epoches, reg_coef)
    print('stachastic_gd_L2:', theta)

    ridge = Ridge(alpha=1, max_iter=1000, solver='sag')
    ridge.fit(x, y)
    print('Ridge:\n', ridge.intercept_, ridge.coef_)

    sgd = SGDRegressor(penalty='l2', alpha=.01, max_iter=1000)
    sgd.fit(x, y.ravel())
    print('SGDRegressor_L2:\n', sgd.intercept_, sgd.coef_)
    # ---------------L2正则-------------- #
    # ---------------L1正则-------------- #
    lasso = Lasso(alpha=.01, max_iter=1000)
    lasso.fit(x, y)
    print('Lasso:\n', lasso.intercept_, lasso.coef_)

    sgd = SGDRegressor(penalty='l1', alpha=.01, max_iter=1000)
    sgd.fit(x, y.ravel())
    print('SGDRegressor_L1:\n', sgd.intercept_, sgd.coef_)
    # ---------------L1正则-------------- #
    '''
    有上面可以看出，关键在于调整正则化系数，不同的算法对数据的学习需要不同的参数设置
    '''
