var findS3 = angular.module('findS3', []);

function mainController($scope, $http) {
	$scope.formData = {};
	
	$http.get('/api/listing')
		.success(function(data) {
			$scope.listing = data;
			console.log(data);
		})
		.error(function(err) {
			console.err("Error", err);	
		});
}