package movienight.controller.command
{
	import movienight.controller.signal.SignalAppDataLoadError;
	import movienight.controller.signal.SignalAppDataLoaded;
	import movienight.enum.ApiURLs;
	import movienight.model.DataModel;
	import movienight.model.service.JSONWebService;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class RequestAppDataCommand extends Command
	{
		
		[Inject]
		public var dataModel : DataModel;
		
		[Inject]
		public var signalAppDataLoaded : SignalAppDataLoaded;
		
		[Inject]
		public var signalAppDataLoadError : SignalAppDataLoadError;
		
		////////////////////////////////////////////////////////////////
		
		override public function execute() : void
		{
			requestQuestionData();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function requestQuestionData() : void 
		{
			new JSONWebService().request( makeUrl( ApiURLs.API_QUESTION_DATA ), null, "GET" )
				.then( onQuestionDataRequestSuccess, onQuestionDataRequestFailed );
		}
		private function onQuestionDataRequestSuccess( result : Object ) : void 
		{
			dataModel.parseCategoryData( result );
			requestLeaderboardData();
		}
		private function onQuestionDataRequestFailed( error : Error ) : void 
		{
			signalAppDataLoadError.dispatch( error );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function requestLeaderboardData() : void
		{
			new JSONWebService().request( makeUrl( ApiURLs.API_LEADER_BOARD ), null, "GET" )
				.then( onLeaderboardDataRequestSuccess, onLeaderboardDataRequestFailed );
		}
		private function onLeaderboardDataRequestSuccess( result : Object ) : void 
		{
			dataModel.parseLeaderboardData( result );
			signalAppDataLoaded.dispatch();
		}
		private function onLeaderboardDataRequestFailed( error : Error ) : void 
		{
			signalAppDataLoadError.dispatch( error );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function makeUrl( callUrl : String ) : String 
		{
			return ApiURLs.API_URL + callUrl;
		}
		
		////////////////////////////////////////////////////////////////
	}
}