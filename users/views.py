from rest_framework import permissions
from rest_framework.response import Response
from rest_framework.views import APIView


class CheckBaseView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        return Response({'status': 'success', 'user': request.user.id})
