package movienight.model.service
{
	import com.codecatalyst.promise.Promise;
	
	import movienight.enum.ApiURLs;
	import movienight.util.Tracer;
	
	public class APIService
	{
		
//		[Inject]
//		public var dataModel : MovieNightDataModel;
		
		////////////////////////////////////////////////////////////////
		
		public function requestQuestionData() : Promise 
		{
			var promise : Promise = new JSONWebService().request( makeUrl( ApiURLs.API_QUESTION_DATA ), null, "GET" );
			promise.then( onQuestionDataRequestSuccess, onQuestionDataRequestFailed );
			return promise;
		}
		private function onQuestionDataRequestSuccess( result : Object ) : void 
		{
			Tracer.out();
//			dataModel.parseCategoryData( result.data );
		}
		private function onQuestionDataRequestFailed( error : Error ) : void 
		{
			Tracer.out();
		}
		
		////////////////////////////////////////////////////////////////
		
		public function requestLeaderboardData() : Promise
		{
			var promise : Promise = new JSONWebService().request( makeUrl( ApiURLs.API_LEADER_BOARD ), null, "GET" );
			promise.then( onLeaderboardDataRequestSuccess, onLeaderboardDataRequestFailed );
			return promise;
		}
		private function onLeaderboardDataRequestSuccess( result : Object ) : void 
		{
			Tracer.out();
//			dataModel.parseCategoryData( result.data );
		}
		private function onLeaderboardDataRequestFailed( error : Error ) : void 
		{
			Tracer.out();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function makeUrl( callUrl : String ) : String 
		{
			return ApiURLs.API_URL + callUrl;
		}
		
		////////////////////////////////////////////////////////////////
	}
}

