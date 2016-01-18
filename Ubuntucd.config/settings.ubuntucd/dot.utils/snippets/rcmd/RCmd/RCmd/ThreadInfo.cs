using System;
using System.Collections.Generic;
using System.Text;

using System.Threading;

namespace YunShu.RCmd
{
	public class ThreadInfo
	{
		public Thread ThreadName;
		public int LiveTime;

		public ThreadInfo(Thread _ThreadName, int _LiveTime )
		{
			this.ThreadName = _ThreadName;
			this.LiveTime = _LiveTime;
		}
	}
}
