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

				// ����Ѿ��������̣߳����ٱ�����Ϣ
				if (CurrentThreadInfo.ThreadName.ThreadState == ThreadState.Stopped)
				{
					WorkThreadPool.Remove(CurrentThreadInfo);
				}

				// �����ʱû�������ϵ��̣߳�ǿ��ɱ�������ӳ��������Ϣ
				// ��ʱ���պ������
				else if (CurrentThreadInfo.LiveTime > Timeout)
				{
					CurrentThreadInfo.ThreadName.Abort();

					if (CurrentThreadInfo.ThreadName.Join(2000))
					{
						WorkThreadPool.Remove(CurrentThreadInfo);
					}
				}

				// ÿ����̵߳��������˵�ʱ������500����
				else
				{
					CurrentThreadInfo.LiveTime += 500;
				}
			}
		}
	}
}
