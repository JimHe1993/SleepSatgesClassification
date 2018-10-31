'''
多项式回归——其本质是对数据空间进行升维，进而将非线性问题转化为高维空间中的线性问题，之后便可以
应用线性回归理论进行问题求解
by Jim 2018.10.31
'''

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression

if __name__ == "__main__":
    mpl.rcParams['font.sans-serif'] = [u'SimHei']
    mpl.rcParams['axes.unicode_minus'] = False

    # 构造数据
    m = 100
    x = 6 * np.random.rand(m, 1) - 3
    y = 0.5 * x ** 2 + x + 2 + np.random.randn(m, 1)

    # 可视化升维数据拟合现象
    plt.plot(x, y, 'b.', label='原始数据')
    label = ['1阶拟合', '2阶拟合', '10阶拟合']
    order = 0

    d = {1: 'g-', 2: 'r+', 10: 'y*'}
    for i in d:
        poly_feature = PolynomialFeatures(degree=i, include_bias=False)  # include_bias=False表示不对截距项进行处理
        x_poly = poly_feature.fit_transform(x)
        # print(x_poly[:5, :])

        lr = LinearRegression(fit_intercept=True, n_jobs=-1)
        lr.fit(x_poly, y)
        print(lr.intercept_, lr.coef_)

        pred = lr.predict(x_poly)
        plt.plot(x_poly[:, 0], pred, d[i], label=label[order])
        order += 1

    plt.legend(loc='best')
    plt.show()

    '''
    升维的作用
    1、升维就是增加更多的影响y的因素，这样考虑更全面，从更多的角度观察数据并可能得到任务的决定性因素，从而提高模型的
    预测准确性
    2、升维可以将非线性问题转化为高维空间的线性问题，这样能尽量使用简单有效的线性模型解决问题
    
    非线性问题的解决思路
    1、使用非线性模型
    2、升维，高维空间下可能变成线性问题，可以利用线性模型求解
    3、使用集成方法，组合简单的线性模型对非线性问题求解
    '''
