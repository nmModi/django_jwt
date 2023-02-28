from django.urls import path

from .views import CheckBaseView


urlpatterns = [
    path('', CheckBaseView.as_view()),
]
