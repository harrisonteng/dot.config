using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace YunShu.RCmd
{
	class ThreadControl
	{
		public static void CleanThread(ArrayList WorkThreadPool, int Timeout)
		{
			ThreadInfo CurrentThreadInfo;

			for (int index = 0; index < WorkThreadPool.Count; index++)
			{
				CurrentThreadInfo = (ThreadInfo)WorkThreadPool[index];

				// 清除已经结束的线程，不再保存信息
				if (CurrentThreadInfo.ThreadName.ThreadState == ThreadState.Stopped)
				{
					WorkThreadPool.Remove(CurrentThreadInfo);
				}

				// 清除超时没有连接上的线程，强行杀掉，并从池中清除信息
				// 超时按照毫秒计算
				else if (CurrentThreadInfo.LiveTime > Timeout)
				{
					CurrentThreadInfo.ThreadName.Abort();

					if (CurrentThreadInfo.ThreadName.Join(2000))
					{
						WorkThreadPool.Remove(CurrentThreadInfo);
					}
				}

				// 每个活动线程的已生存了的时间增加500毫秒
				else
				{
					CurrentThreadInfo.LiveTime += 500;
				}
			}
		}
	}
}
